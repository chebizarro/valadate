namespace Valadate.Tests.Utils {
	
	using Valadate;

    public class AsyncTest : TestCase {

		public AsyncTest() {
			//add_test("non-cancellable", test_noncancellable);
			//add_test("cancellable", test_cancellable);
		}

        //public override void set_up() { set_timeout(1000); }

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
