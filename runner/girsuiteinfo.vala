/*
 * Valadate - Unit testing library for GObject-based libraries.
 * Copyright (C) 2009  Jan Hudec <bulb@ucw.cz>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published
 * by the Free Software Foundation, either version 3 of the License, or (at
 * your option) any later version.
 *
 * This program is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
 * or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Lesser General Public
 * License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */


using GLib;
using Introspection;
using Vala;

namespace ValadateRunner {
    class GirSuiteInfo : SuiteInfo {
        ObjectInfo fx_info;

        public GirSuiteInfo(ObjectInfo fx_info)
            throws RunnerError, InvokeError
        {
            base(fx_info.get_g_type());
            this.fx_info = fx_info;
        }

        public void create_tests(TestSuite suite) throws InvokeError {
            var fn_infos = new ArrayList<FunctionInfo>();
            gather_methods(fx_info, ref fn_infos);
            foreach(var fn_info in fn_infos) {
                if(!is_generator(fn_info))
                    continue;
                if(verbose)
                    stdout.printf("        found generator %s\n",
                            fn_info.get_name());
                add_generator(fn_info.get_name().substring(9).delimit("_",
                            '-'), (Generator)get_fn_pointer(fn_info));
            }
            foreach(var fn_info in fn_infos) {
                if(!is_test(fn_info))
                    continue;
                switch(test_type(fn_info)) {
                    case TestType.SYNC:
                        if(verbose)
                            stdout.printf("        found test %s\n",
                                    fn_info.get_name());
                        add_test(suite, fn_info.get_name().substring(5),
                                test_marshal_synchronous, get_fn_pointer(fn_info),
                                null);
                        break;
                    case TestType.ASYNC:
                        var finish_info = get_finish(fn_info);
                        if(finish_info != null) {
                            add_test(suite, fn_info.get_name().substring(5),
                                    test_marshal_asynchronous,
                                    get_fn_pointer(fn_info),
                                    get_fn_pointer(finish_info));
                        } else {
                            warning("%s.%s.%s looks like an async test, but matching finish method was not found.",
                                    fx_info.get_namespace(), fx_info.get_name(),
                                    fn_info.get_name());
                        }
                        break;
                    case TestType.CANCELLABLE:
                        var finish_info = get_finish(fn_info);
                        if(finish_info != null) {
                            add_test(suite, fn_info.get_name().substring(5),
                                    test_marshal_cancellable,
                                    get_fn_pointer(fn_info),
                                    get_fn_pointer(finish_info));
                        } else {
                            warning("%s.%s.%s looks like a cancellable async test, but matching finish method was not found.",
                                    fx_info.get_namespace(), fx_info.get_name(),
                                    fn_info.get_name());
                        }
                        break;
                    default:
                        warning("%s.%s.%s is named like a test, but it's signature is not of any supported type",
                                fx_info.get_namespace(), fx_info.get_name(),
                                fn_info.get_name());
                        break;
                }
            }
        }

        private void gather_methods(ObjectInfo fx_info,
                ref ArrayList<FunctionInfo> fn_infos) {
            if(verbose)
                stdout.printf("        gathering methods in %s\n",
                        fx_info.get_name());
            int n_funcs = fx_info.get_n_methods();
            for(int i = 0; i < n_funcs; ++i) {
                fn_infos.add(fx_info.get_method(i));
                if(verbose)
                    stdout.printf("            found %s\n",
                            fx_info.get_method(i).get_name());
            }

            var base_info = fx_info.get_parent();
            if(base_info != null && base_info.get_type() == InfoType.OBJECT)
                gather_methods(base_info, ref fn_infos);
            // FIXME: Search interfaces too! (they are different info
            // type, so need different iteration)
            // Oh, by the way, they should be searched before parent,
            // And we need to check method under that name is not already
            // listed to properly handle shadowing/overriding.
        }

        private bool is_generator(FunctionInfo? fn) {
            // FIXME: Use our own warnings.
            if(!fn.get_name().has_prefix("generate_"))
                return false;
            return_val_if_fail(fn != null, false);
            return_val_if_fail(fn.get_type() ==
                    InfoType.FUNCTION, false); // Wrong info type
            return_val_if_fail(fn.get_flags() == 0, false); // Not a static function
            var return_type = fn.get_return_type();
            return_val_if_fail(return_type.get_tag() ==
                    TypeTag.INTERFACE, false); // Wrong return type
            var return_iface = return_type.get_interface();
            return_val_if_fail(return_iface != null &&
                    return_iface.get_name() == "ValueArray" &&
                    return_iface.get_namespace() == "GLib",
                    false); // Wrong return type
            return_val_if_fail(fn.get_n_args() == 0, false); // Has arguments
            return true;
        }

        private bool is_test(FunctionInfo method) {
            if((method.get_flags() & FunctionInfoFlags.IS_METHOD) == 0)
                return false; // Test must be an instance method.
            if(!method.get_name().has_prefix("test_"))
                return false; // Tests are methods starting with "test_".
            if(method.get_return_type().get_tag() != TypeTag.VOID)
                return false; // Tests must return void.
            // FIXME: Generic methods?
            // if(method.get_n_args() != 0)
            //    return false; // Test methods must take no additional arguments.
            return true;
        }

        private enum TestType {
            NONE,
            SYNC,
            ASYNC,
            CANCELLABLE,
        }

        private TestType test_type(FunctionInfo method) {
            if(method.get_n_args() == 0)
                return TestType.SYNC;
            if(method.get_n_args() == 2) {
                var arg0 = method.get_arg(0).get_type();
                var arg1 = method.get_arg(1).get_type();
                if(arg0.get_tag() != TypeTag.INTERFACE ||
                        arg0.get_interface().get_name() != "AsyncReadyCallback" ||
                        arg1.get_tag() != TypeTag.VOID ||
                        !arg1.is_pointer())
                    return TestType.NONE;
                return TestType.ASYNC;
            }
            if(method.get_n_args() == 3) {
                var arg0 = method.get_arg(0).get_type();
                var arg1 = method.get_arg(1).get_type();
                var arg2 = method.get_arg(2).get_type();
                if(arg0.get_tag() != TypeTag.INTERFACE ||
                        arg0.get_interface().get_name() != "Cancellable" ||
                        arg1.get_tag() != TypeTag.INTERFACE ||
                        arg1.get_interface().get_name() != "AsyncReadyCallback" ||
                        arg2.get_tag() != TypeTag.VOID ||
                        !arg2.is_pointer())
                    return TestType.NONE;
                return TestType.CANCELLABLE;
            }
            return TestType.NONE;
        }

        private FunctionInfo? get_finish(FunctionInfo begin_info) {
            string name = begin_info.get_name();
            if(name.has_suffix("_async"))
                name = name.substring(0, name.length - 5);
            name += "_finish";
            var finish_info = fx_info.find_method(name);
            if(finish_info == null)
                return null;
            if(finish_info.get_n_args() != 1)
                return null;
            var arg = finish_info.get_arg(0).get_type();
            if(arg.get_tag() != TypeTag.INTERFACE)
                return null;
            if(arg.get_interface().get_name() != "AsyncResult")
                return null;
            return finish_info;
        }

        private void *get_fn_pointer(FunctionInfo fn_info) throws InvokeError {
            string symname = fn_info.get_symbol();
            void *symbol;
            if(!fn_info.get_typelib().symbol(symname, out symbol))
                throw new InvokeError.SYMBOL_NOT_FOUND("Could not find %s: %s\n",
                        symname, Module.error());
            return symbol;
        }
    }
}

