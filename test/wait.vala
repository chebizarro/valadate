using GLib;
using Valadate;

namespace Test {
	internal class Changer : Object {
		private uint timer = 0;

		public uint count { get; set; default = 0; }

		public void start() {
			stop();
			timer = Timeout.add(100, this.tick);
		}

		public async void inc_async() {
			timer = Timeout.add(100, inc_async.callback);
			yield;
			stop();
			count++;
		}

		delegate void CancelledHandler(Object emitter);

		/* FIXME: Does not work until closures in async are fixed.
		public async void cancellable_inc_async(Cancellable cancel) {
			SourceFunc acb = cancellable_inc_async.callback;
			cancel.cancelled.connect((o) => { acb(); });
			timer = Timeout.add(100,
					cancellable_inc_async.callback);
			yield;
			// FIXME FIXME FIXME: I need to disconnect, but
			// I don't know how!
			//cancel.cancelled.disconnect((o) => { acb(); });
			stop();
			count++;
		}
		*/

		public void stop() {
			if(timer != 0)
				Source.remove(timer);
			timer = 0;
		}

		~Changer() {
			stop();
		}

		private bool tick() {
			count++;
			return true;
		}
	}

	/* Here we test the wait_* functions. */
	public class TestWait : Object, Fixture {
		Changer changer = new Changer();

		public void test_wait_signal_normal() {
			assert(wait_for_signal(500, changer, "notify::count",
						() => changer.start()));
			assert(changer.count == 1);
		}

		public void test_wait_signal_immediate() {
			assert(wait_for_signal(200, changer, "notify::count",
						() => { changer.count = 5; }));
			assert(changer.count == 5);
		}

		public void test_wait_signal_fail() {
			assert(!wait_for_signal(200, changer, "notify::count",
						() => {}));
			assert(changer.count == 0);
		}

		public void test_wait_condition_normal() {
			assert(wait_for_condition(500, changer, "notify::count",
						() => changer.count == 4,
						() => changer.start()));
			assert(changer.count == 4);
		}

		public void test_wait_condition_immediate() {
			assert(wait_for_condition(200, changer, "notify::count",
						() => true,
						() => changer.start()));
			assert(changer.count == 0);
		}

		public void test_wait_condition_fail() {
			assert(!wait_for_condition(250, changer, "notify::count",
						() => changer.count == 4,
						() => changer.start()));
			assert(changer.count == 2);
		}

		public void test_wait_async_normal() {
			assert(wait_for_async(200, (cb) => changer.inc_async(cb),
						res => changer.inc_async.end(res)));
			assert(changer.count == 1);
		}

		public void test_wait_async_fail() {
			assert(!wait_for_async(20, (cb) => changer.inc_async(cb),
						res => changer.inc_async.end(res)));
			assert(changer.count == 0);
		}

		/*
		public void test_wait_cancellable_async_normal() {
			assert(wait_for_cancellable_async(200,
						changer.cancellable_inc_async,
						res => changer.cancellable_inc_async.end(res)));
			assert(changer.count == 1);
		}

		public void test_wait_cancellable_async_fail() {
			assert(wait_for_cancellable_async(20,
						changer.cancellable_inc_async,
						res => changer.cancellable_inc_async.end(res)));
			assert(changer.count == 1); // The increment is done on cancel anyway!
		}*/
	}
}
