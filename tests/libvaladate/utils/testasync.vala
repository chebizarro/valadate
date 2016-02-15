namespace Valadate.Tests.Utils {
	
	using Valadate;

	public class TestAsync : TestCase {

		public TestAsync() {
			add_async_test( "AsyncWithTimeout",
							cb => test_async_with_timeout.begin( cb ),
							res => test_async_with_timeout.end( res ),
							4000 );
			add_async_test( "Async",
							cb => do_calc_in_bg.begin( cb ),
							res => do_calc_in_bg.end( res ));
		}

		public async void test_async_with_timeout()
			throws GLib.Error, AssertError {
			var dir = File.new_for_path (Environment.get_home_dir());
			var e = yield dir.enumerate_children_async(
				FileAttribute.STANDARD_NAME, 0, Priority.DEFAULT, null);
			while (true) {
				var files = yield e.next_files_async(10, Priority.DEFAULT, null);
				if (files == null) {
					break;
				}
				foreach (var info in files) {
					message("%s\n", info.get_name());
				}
			}
		}
		
		public async void do_calc_in_bg() throws ThreadError {
			SourceFunc callback = do_calc_in_bg.callback;
			double[] output = new double[1];
			double val = 1000.00;
			// Hold reference to closure to keep it from being freed whilst
			// thread is active.
			ThreadFunc<void*> run = () => {
				// Perform a dummy slow calculation.
				// (Insert real-life time-consuming algorithm here.)
				double result = 0;
				for (int a = 0; a<10000000; a++)
					result += val * a;

				// Pass back result and schedule callback
				output[0] = result;
				Idle.add((owned) callback);
				return null;
			};
			Thread.create<void*>(run, false);

			// Wait for background thread to schedule our callback
			yield;
			Assert.equals(49999995000000000, (int64)output[0]);
		}
	}
}
