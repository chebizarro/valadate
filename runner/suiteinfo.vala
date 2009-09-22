using GLib;

namespace ValadateRunner {
    static delegate ValueArray Generator();

    class ParamInfo {
        public string name;
        public ValueArray values;

        // TODO: Variant for class generator instead of static and maybe for
        // Value[]-returning generators.
        public ParamInfo(string name, Generator gen) {
            this.name = name;
            this.values = gen();
        }

        public Parameter to_parameter(int i) {
            Parameter rv = Parameter();
            rv.name = name;
            rv.value = values.values[i];
            return rv;
        }

        public string to_name(int i) {
            return ",%s=%i".printf(name, i);
        }
    }

    class SuiteInfo {
        private Type type;
        private ObjectClass klass;
        private SList<ParamInfo>? parameters = null;
        private SList<TestInfo>? tests = null;

        public SuiteInfo(Type type) throws RunnerError
        {
            if(!type.is_a(typeof(Object)))
                throw new RunnerError.TYPE_NOT_LOADED("Type %s is not an Object",
                        type.name());
            this.type = type;
            this.klass = (ObjectClass)type.class_ref();
        }

        protected void add_generator(string prop, Generator gen) {
            weak ParamSpec? pspec = klass.find_property(prop);
            if(pspec == null) {
                if(verbose)
                    stdout.printf("No property found for generator generate_%s in type %s\n",
                            prop, type.name());
                return;
            }
            for(weak SList<ParamInfo> i = parameters; i != null; i = i.next) {
                if(i.data.name == prop) {
                    if(verbose)
                        stdout.printf("Multiple generators generate_%s in type %s\n",
                                prop, type.name());
                    return;
                }
            }
            parameters.prepend(new ParamInfo(prop, gen));
        }

        protected void add_test(TestSuite suite, string name,
                TestMarshaller marshaller, void *arg1, void *arg2) {
            parametrize_test(suite, marshaller, arg1, arg2, parameters,
                    new Parameter[0], name);
        }

        private void parametrize_test(TestSuite suite,
                TestMarshaller marshaller, void *arg1, void *arg2,
                SList<ParamInfo>? next_param, owned Parameter[] prefix,
                string name) {
            if(next_param == null) { // No more parameters
                if(verbose)
                    stdout.printf("             creating test case %s\n",
                            name);
                var test = new TestInfo(type, marshaller, arg1, arg2,
                        prefix);
                suite.add(test.make_case(name));
                tests.prepend((owned)test);
            } else { // We need to permute...
                var p = next_param.data;
                var n_values = p.values.n_values;
                for(int i = 0; i < n_values; ++i) {
                    var new_params = prefix;
                    new_params += p.to_parameter(i);
                    parametrize_test(suite, marshaller, arg1, arg2,
                            next_param.next, (owned)new_params, name
                            + p.to_name(i));
                }
            }
        }
    }
}
