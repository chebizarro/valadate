using GLib;
using Introspection;

namespace ValadateRunner {
    static delegate void TestMarshaller(Valadate.Fixture fixture, void *arg1, void *arg2);

    struct FixturePointer {
        public Valadate.Fixture fixture;
    }

    class TestInfo {
        Type type;
        TestMarshaller marshaller;
        void *arg1;
        void *arg2;
        Parameter[] parameters;

        public TestInfo(Type type, TestMarshaller marshaller, void *arg1,
                void *arg2, owned Parameter[] parameters) {
            this.type = type;
            this.marshaller = marshaller;
            this.arg1 = arg1;
            this.arg2 = arg2;
            this.parameters = parameters;
        }

        public TestCase make_case(string name) {
            /*
            if(type == typeof(void))
                throw new RunnerError.TYPE_NOT_LOADED(
                        "Bad type in ",
                        fx_info.get_namespace(),
                        fx_info.get_name());
                        */
            return new TestCase(name,
                    sizeof(FixturePointer), this.set_up,
                    this.run, this.tear_down);
        }

        // Interface for the GTestCase.
        private void set_up(void * data) {
            FixturePointer *fp = data;
            // FIMXE: The params will have to be here, but binding for g_object_newv is needed first...
            fp->fixture = Object.newv(type, parameters) as Valadate.Fixture;
            fp->fixture.set_up();
        }

        private void tear_down(void * data) {
            FixturePointer *fp = data;
            fp->fixture.tear_down();
            fp->fixture = null; // Should delete the object.
        }

        private void run(void * data) {
            FixturePointer *fp = data;
            marshaller(fp->fixture, arg1, arg2);
            // FIXME: Mark the test case as passed if we got this far
        }
        // End Interface
    }

    // Marshallers
    static delegate void TestMethodSync(Valadate.Fixture fx);
    void test_marshal_synchronous(Valadate.Fixture it, void *arg1, void *arg2) {
        ((TestMethodSync)arg1)(it);
    }
}
