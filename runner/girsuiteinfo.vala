using Gee;
using GLib;
using Introspection;

namespace ValadateRunner {
    class ParamInfo {
        public PropertyInfo property;
        public ValueArray values;

        public ParamInfo(PropertyInfo property, FunctionInfo generator)
            throws InvokeError
        {
            this.property = property;
            Argument ret;
            generator.invoke(new Argument[0], new Argument[0], out ret);
            // FIXME: Must not copy -- the pointer would be leaked
            // values = (owned ValueArray)ret.pointer // is what I want, but can't easily do...
            values = ret.steal_value_array();
        }

        public Parameter to_parameter(int i) {
            Parameter rv = Parameter();
            rv.name = property.get_name();
            rv.value = values.values[i];
            return rv;
        }

        public string to_name(int i) {
            return ",%s=%i".printf(property.get_name(), i);
        }
    }

    class GirSuiteInfo {
        ObjectInfo fx_info;
        SList<ParamInfo>? parameters = null;
        SList<TestInfo>? tests = null; // Stash away the TestInfo objects, because TestCase does not hold them

        public GirSuiteInfo(ObjectInfo fx_info)
            throws RunnerError, InvokeError
        {
            this.fx_info = fx_info;

            var prop_infos = new Gee.ArrayList<PropertyInfo>();
            gather_properties(fx_info, ref prop_infos);
            foreach(PropertyInfo prop_info in prop_infos) {
                var pn = prop_info.get_name();
                var gen_info = find_generator(fx_info,
                        "generate_" + pn);
                if(gen_info != null) {
                    if(verbose)
                        stdout.printf("        found generator for %s\n", pn);
                    parameters.prepend(
                        new ParamInfo(prop_info, gen_info));
                }
            }
        }

        public void create_tests(TestSuite suite) {
            var n_methods = fx_info.get_n_methods();
            for(int i = 0; i < n_methods; ++i) {
                var method = fx_info.get_method(i);
                // FIXME: progress message
                if(verbose)
                    stdout.printf("        checking method %s\n",
                            method.get_name());
                if(!is_test(method))
                    continue;
                if(verbose)
                    stdout.printf("        found test %s\n",
                            method.get_name());
                parametrize_tests(method, suite, parameters,
                        new Parameter[0],
                        method.get_name().substring(5));
            }
        }

        private void gather_properties(ObjectInfo fx_info,
                ref ArrayList<PropertyInfo> prop_infos) {
            if(verbose)
                stdout.printf("        gathering properties in %s\n",
                        fx_info.get_name());
            int n_props = fx_info.get_n_properties();
            for(int i = 0; i < n_props; ++i) {
                prop_infos.add(fx_info.get_property(i));
                if(verbose)
                    stdout.printf("            found %s\n",
                            fx_info.get_property(i).get_name());
            }

            var base_info = fx_info.get_parent();
            if(base_info != null && base_info.get_type() ==
                    InfoType.OBJECT)
                gather_properties(base_info, ref prop_infos);

            // FIXME: Search interfaces too! (they are different info
            // type, so need different iteration; I don't know whether
            // I won't find the properties on the type itself though).
            // Oh, by the way, they should be searched before parent,
            // (I assume they are only directly implemented ones, not
            // inherited ones -- if not, we are in trouble).

            // TESTME: Overriden properties don't show up again.
            // (if they do, we have to check a property is not listed
            // when adding new one)
        }

        private FunctionInfo? check_generator(owned FunctionInfo? fn) {
            // FIXME: Use our own warnings.
            return_val_if_fail(fn != null, null);
            return_val_if_fail(fn.get_type() ==
                    InfoType.FUNCTION, null); // Wrong info type
            return_val_if_fail(fn.get_flags() == 0, null); // Not a static function
            var return_type = fn.get_return_type();
            return_val_if_fail(return_type.get_tag() ==
                    TypeTag.INTERFACE, null); // Wrong return type
            var return_iface = return_type.get_interface();
            return_val_if_fail(return_iface != null &&
                    return_iface.get_name() == "ValueArray" &&
                    return_iface.get_namespace() == "GLib",
                    null); // Wrong return type
            return_val_if_fail(fn.get_n_args() == 0, null); // Has arguments
            return fn;
        }

        private FunctionInfo? find_generator(ObjectInfo info, string name) {
            if(verbose)
                stdout.printf("            searching for %s in %s\n",
                        name, info.get_name());
            FunctionInfo fn = info.find_method(name);
            if(fn != null) {
                return check_generator(fn);
            }
            var n_ifs = info.get_n_interfaces();
            for(int i = 0; i < n_ifs; ++i) {
                var iface = info.get_interface(i);
                fn = iface.find_method(name);
                if(fn != null)
                    return check_generator(fn);
            }
            var parent = info.get_parent();
            if(parent != null && parent.get_type() == InfoType.OBJECT)
                return find_generator((ObjectInfo)parent, name);
            return null;
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

        private void parametrize_tests(FunctionInfo method, TestSuite suite,
                SList<ParamInfo>? next_param, owned Parameter[]
                prefix, string name) {
            if(next_param == null) { // No more parameters
                if(verbose)
                    stdout.printf("            creating test case %s\n", name);
                var test = new TestInfo(fx_info, method, prefix);
                suite.add(test.make_case(name));
                tests.prepend((owned)test);
            } else { // So we need to permute...
                var p = next_param.data;
                var n_values = p.values.n_values;
                for(int i = 0; i < n_values; ++i) {
                    var new_params = prefix;
                    new_params += p.to_parameter(i);
                    parametrize_tests(method, suite,
                            next_param.next,
                            (owned)new_params,
                            name + p.to_name(i));
                }
            }
        }
    }
}

