using Gee;
using GLib;
using Introspection;

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
                if(verbose)
                    stdout.printf("        found test %s\n",
                            fn_info.get_name());
                add_test(suite, fn_info.get_name().substring(5),
                        test_marshal_synchronous, get_fn_pointer(fn_info),
                        null);
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
            if(method.get_n_args() != 0)
                return false; // Test methods must take no additional arguments.
            return true;
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

