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

	private class TestAdaptor : Object, Test {

		public string name {get;set;}
		public string label {get;set;}
		public bool skipped {get;set;default=false;}
		public bool failed {get;set;default=false;}

		public int count {
			get {
				return 1;
			}
		}

		private TestMethod test;
		private TestCase testcase;

		private static TestResult result;
		private static Test sthis;

		public new Test get(int index) {
			return this;
		}

		public TestAdaptor(string name, owned TestMethod test, TestCase testcase) {
			this.test = (owned)test;
			this.name = name;
			this.testcase = testcase;
		}

		public void run(TestResult result) {
			result = result;
			sthis = this;
			GLib.set_printerr_handler (printerr_func);
			this.testcase.set_up();
			try {
				this.test();
			} catch (Error e) {
				result.add_failure(this, e.message);
			}
			this.testcase.tear_down();
			if(!skipped && !failed)
				result.add_success(this, "");
		}

		private static void printerr_func (string? text) {
			if (text == null || str_equal (text, ""))
				return;

			/*
			var fields = text.split(":");
			result.add_error(sthis, "FAIL: %s: %s:%s:%s:%s:%s".printf(
				fields[0].substring(3), Path.get_basename(fields[1]), fields[2],
				sthis.name, fields[4], fields[5]
			));*/
			result.add_failure(sthis, text);
			result.report();
			/* Print a stack trace since we've hit some major issue */
			GLib.on_error_stack_trace ("libtool --mode=execute gdb");
		}


		private void log_func (
			string? log_domain,
			LogLevelFlags log_levels,
			string? message)	{
			if ((log_levels & (
				LogLevelFlags.LEVEL_WARNING |
				LogLevelFlags.LEVEL_CRITICAL)) != 0) {
				//GLib.on_error_stack_trace ("libtool --mode=execute gdb");
				result.add_error(this, message);
				//result.report();
				//return;

			} else if ((log_levels &
				(LogLevelFlags.LEVEL_INFO)) != 0) {
				
				var str = message.split(":")[2];
				if(str.has_prefix("#SKIP ")) {
					skipped = true;
					result.add_skip(this, str, "");
					//return;
				}
			}
			Log.default_handler (log_domain, log_levels, message);
		}

	}
}
