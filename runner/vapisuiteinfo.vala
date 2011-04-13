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
using Vala;

namespace ValadateRunner {
    
    [CCode (has_target = false)]
    delegate Type GetType();
            
    class VapiSuiteInfo : SuiteInfo {
        static Module[] modules = null;
        static bool modules_loaded = false;

        private Class cl;

        public VapiSuiteInfo(Class cl) throws RunnerError {
            base(get_g_type(cl));
            this.cl = cl;
        }

        public void create_tests(TestSuite suite) throws RunnerError {
            var methods = new ArrayList<Method>();
            gather_methods(cl, ref methods);
            foreach(var method in methods) {
                if(!is_generator(method))
                    continue;
                if(verbose)
                    stdout.printf("        found generator %s\n",
                            method.name);
                add_generator(method.name.substring(9).delimit("_",
                            '-'),
                        (Generator)load_symbol(method.get_cname()));
            }
            foreach(var method in methods) {
                if(!is_test(method))
                    continue;
                switch(test_type(method)) {
                    case TestType.SYNC:
                        if(verbose)
                            stdout.printf("        found sync test %s\n",
                                    method.name);
                        add_test(suite, method.name.substring(5),
                                test_marshal_synchronous,
                                load_symbol(method.get_cname()), null);
                        break;
                    case TestType.ASYNC:
                        if(verbose)
                            stdout.printf("        found async test %s\n",
                                    method.name);
                        add_test(suite, method.name.substring(5),
                                test_marshal_asynchronous,
                                load_symbol(method.get_cname()),
                                load_symbol(method.get_finish_cname()));
                        break;
                    case TestType.CANCELLABLE:
                        if(verbose)
                            stdout.printf("        found cancellable test %s\n",
                                    method.name);
                        add_test(suite, method.name.substring(5),
                                test_marshal_cancellable,
                                load_symbol(method.get_cname()),
                                load_symbol(method.get_finish_cname()));
                        break;
                }
            }
        }

        private void gather_methods(ObjectTypeSymbol ots, ref
                ArrayList<Method> methods) {
            foreach(var method in ots.get_methods()) {
                methods.add(method);
            }
            if(ots is Class) {
                foreach(var base_type in ((Class)ots).get_base_types()) {
                    gather_methods((ObjectTypeSymbol)base_type.data_type,
                            ref methods);
                }
            }
        }

        private bool is_generator(Method method) {
            if(!method.name.has_prefix("generate_")) {
                return false;
            }
            if(method.binding != MemberBinding.STATIC) {
                warning("%s is named like a generator, but it's not static",
                        method.name);
                return false;
            }
            if(method.get_type_parameters().size != 0){
                warning("%s is named like a generator, but it is generic (with %i type params)",
                        method.name, method.get_type_parameters().size);
                return false; // Must not be generic
            }
            if(method.get_parameters().size != 0){
                warning("%s is named like a generator, but it has %i parameters",
                        method.name, method.get_parameters().size);
                return false; // Must have no arguments
            }
            if(method.tree_can_fail) {
                warning("%s is named like a generator, but it throws error",
                        method.name);
                return false;
            }
            if(method.return_type.data_type == null ||
                    method.return_type.data_type.get_full_name() != "GLib.ValueArray") {
                warning("%s is named like a generator, but it does not return GLib.ValueArray",
                        method.name);
                return false; // Must return ValueArray
            }
            return true;
        }

        private bool is_test(Method method) {
            if(!method.name.has_prefix("test_"))
                return false;
            if(method.binding != MemberBinding.INSTANCE) {
                warning("%s is named like a test, but it it not an instance method",
                        method.name);
                return false;
            }
            if(method.return_type.get_cname() != "void") {
                warning("%s is named like a test, but it has non-void return type",
                        method.name);
                return false;
            }
            if(method.tree_can_fail) {
                warning("%s is named like a test, but it throws error",
                        method.name);
                return false;
            }
            if(method.get_type_parameters().size != 0){
                warning("%s is named like a test, but is generic with %i type params",
                        method.name, method.get_type_parameters().size);
                return false; // Must not be generic
            }
            return true;
        }

        private enum TestType {
            NONE,
            SYNC,
            ASYNC,
            CANCELLABLE,
        }

        private TestType test_type(Method method) {
            if(method.coroutine) { // async
                if(method.get_parameters().size == 0) {
                    return TestType.ASYNC;
                }
                if(method.get_parameters().size == 1 &&
                        method.get_parameters().get(0).variable_type.to_string() == "GLib.Cancellable") {
                    return TestType.CANCELLABLE;
                }
                warning("%s is named like a test, but async test must have either no parameters or one parameter of type GLib.Cancellable",
                        method.name);
            } else { // sync
                if(method.get_parameters().size == 0) {
                    return TestType.SYNC;
                }
                warning("%s is named like a test, but has %i parameters",
                        method.name, method.get_parameters().size);
            }
            return TestType.NONE;
        }

        private static Type get_g_type(Class cl) throws RunnerError {
            load_modules();

            GetType get_type = (GetType)load_symbol(
                    cl.get_lower_case_cprefix() + "get_type");
            Type type = get_type();
            if(verbose)
                stdout.printf("        Loaded type %i (%s) for class %s\n",
                        type, type.name(), cl.get_full_name());
            return type;
        }

        private static void load_modules() throws RunnerError {
            if(modules_loaded)
                return;

            foreach(weak string name in libs) {
                Module? mod = load_module(name);
                if(mod != null)
                    modules += (owned)mod;
            }
            // XXX: Do we need to open null module too?

            modules_loaded = true;
        }

        private static Module? load_module(string name) {
            Module? mod = null;
            foreach(weak string dir in path) {
                mod = Module.open(Module.build_path(dir, name),
                        ModuleFlags.BIND_LAZY|ModuleFlags.BIND_LOCAL);
                if(mod != null)
                    return mod;
            }
            mod = Module.open(Module.build_path(null, name),
                    ModuleFlags.BIND_LAZY|ModuleFlags.BIND_LOCAL);
            return mod;
        }

        private static void *load_symbol(string name) throws RunnerError {
            void *sym = null;
            foreach(weak Module mod in modules) {
                if(mod.symbol(name, out sym))
                    return sym;
            }
            throw new RunnerError.TYPE_NOT_LOADED("Symbol %s not found.\n",
                    name);
        }
    }
}
