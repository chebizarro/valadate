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
            return new TestCase(name, this.set_up,
                    this.run, this.tear_down, sizeof(FixturePointer));
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
    static delegate void TestMethodAsync(Valadate.Fixture fx,
            AsyncReadyCallback callback);
    static delegate void TestMethodCancellable(Valadate.Fixture fx,
            Cancellable cancel, AsyncReadyCallback callback);
    static delegate void TestMethodFinish(Valadate.Fixture fx,
            AsyncResult result);

    void test_marshal_synchronous(Valadate.Fixture it, void *arg1, void *arg2) {
        ((TestMethodSync)arg1)(it);
    }


    void test_marshal_asynchronous(Valadate.Fixture it, void *arg1, void *arg2) {
        // FIXME: Configurable timeout
        assert(Valadate.wait_for_async(5000,
                    (cb) => ((TestMethodAsync)arg1)(it, cb),
                    (r) => ((TestMethodFinish)arg2)(it, r)));
    }

    void test_marshal_cancellable(Valadate.Fixture it, void *arg1, void *arg2) {
        // FIXME: Configurable timeout
        assert(Valadate.wait_for_cancellable_async(5000,
                    (c, cb) => ((TestMethodCancellable)arg1)(it, c, cb),
                    (r) => ((TestMethodFinish)arg2)(it, r)));
    }
}
