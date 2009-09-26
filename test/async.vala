using GLib;
using Valadate;

namespace Test {
    public class AsyncTest : Object, Fixture {
        public void set_up() { timeout = 1000; }

        public async void test_noncancellable() {
            Timeout.add(100, test_noncancellable.callback);
            yield;
            assert(1 == 1);
        }

        public async void test_cancellable(Cancellable cancel) {
            SourceFunc acb = test_cancellable.callback;
            cancel.cancelled.connect((o) => { acb(); });
            Timeout.add(100, test_cancellable.callback);
            yield;
            assert(1 == 1);
        }
    }
}
