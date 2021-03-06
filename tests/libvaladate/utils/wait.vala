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

using Valadate;

namespace Valadate.Utils.Tests {
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
            timer = 0; // callback returns false so it will be removed automagically
            count++;
        }

        delegate void CancelledHandler(Object emitter);

        public async void cancellable_inc_async(Cancellable cancel) {
            SourceFunc acb = cancellable_inc_async.callback;
            // XXX: Since GLib 2.22 the g_simple_async_result_finish checks
            // the source, so we are only allowed to destroy it after that.
            // However, it is called at very end of the callback, so we have
            // to connect closures to stop it after the callback completes.
            cancel.cancelled.connect((o) => { acb(); stop(); });
            timer = Timeout.add(100,
                    () => { acb(); stop(); return false; });
            yield;
            // FIXME FIXME FIXME: I need to disconnect, but
            // I don't know how!
            //cancel.cancelled.disconnect((o) => { acb(); });
            count++;
        }

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
    public class TestWait : Framework.TestCase {
		
        Changer changer = new Changer();

		public TestWait() {
			add_test("wait_signal_normal", test_wait_signal_normal);
			//add_test("wait_signal_immediate", test_wait_signal_immediate);
			//add_test("wait_signal_fail", test_wait_signal_fail);
			//add_test("wait_condition_normal", test_wait_condition_normal);
			//add_test("wait_condition_immediate", test_wait_condition_immediate);
			//add_test("wait_condition_fail", test_wait_condition_fail);
		}

        public override void tear_down() {
            // The timeout is added owned, so the object won't be
            // destroyed before it's stopped. So we have to do it
            // manually.
            changer.stop();
        }

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
            assert(wait_for_async(200, (cb) => changer.inc_async.begin(cb),
                        res => changer.inc_async.end(res)));
            assert(changer.count == 1);
        }

        public void test_wait_async_fail() {
            assert(!wait_for_async(20, (cb) => changer.inc_async.begin(cb),
                        res => changer.inc_async.end(res)));
            assert(changer.count == 0);
        }

        public void test_wait_cancellable_async_normal() {
            assert(wait_for_cancellable_async(200,
                        (c, cb) => changer.cancellable_inc_async.begin(c, cb),
                        res => changer.cancellable_inc_async.end(res)));
            assert(changer.count == 1);
        }

        public void test_wait_cancellable_async_fail() {
            assert(!wait_for_cancellable_async(20,
                        (c, cb) => changer.cancellable_inc_async.begin(c, cb),
                        res => changer.cancellable_inc_async.end(res)));
            assert(changer.count == 1); // The increment is done on cancel anyway!
        }
    }
}
