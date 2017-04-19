/*
 * Valadate - Unit testing library for GObject-based libraries.
 * Copyright (C) 2016  Chris Daley <chebizarro@gmail.com>
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.

 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.

 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301  USA
 * 
 * Authors:
 * 	Chris Daley <chebizarro@gmail.com>
 */
 
namespace Valadate {

	private class AsyncTestAdapter : TestAdapter {

		public AsyncBegin async_begin;
		public AsyncFinish async_finish;
		public int async_timeout { get; set; }

		public AsyncTestAdapter(string name) {
			base(name);
		}

		public void add_async_test (
			owned AsyncBegin async_begin,
			owned AsyncFinish async_finish,
			int timeout = 200)
		{
			async_begin = (owned)async_begin;
			async_finish = (owned)async_finish;
			async_timeout = timeout;
		}

		public override void run(TestResult result) {
			try	{
				assert( wait_for_async (
					async_timeout, this.async_begin, this.async_finish) );
			}
			catch (GLib.Error err) {
				message(@"Got exception while excuting asynchronous test: $(err.message)");
				GLib.Test.fail();
			}
		}


		public void run(TestResult result) {
			if(status == TestStatus.SKIPPED)
				return;
			var p = parent as TestCase;
			result.add_test(this);
			p.set_up();
			try {
				test();
			} catch (Error e) {
				result.add_failure(this, e.message);
			}
			p.tear_down();
			result.add_success(this);
		}
	}
}
