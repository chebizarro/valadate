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

	public class SerialTestRunner : Object, TestRunner {

		construct {
			
			Environment.set_variable("G_MESSAGES_DEBUG", "all", true);
			
			//GLib.set_printerr_handler (printerr_func_stack_trace);
			//Log.set_default_handler (log_func_stack_trace);
		}

		private static void printerr_func_stack_trace (string? text) {
			if (text == null || str_equal (text, ""))
				return;
			stderr.printf (text);

			/* Print a stack trace since we've hit some major issue */
			GLib.on_error_stack_trace ("libtool --mode=execute gdb");
		}

		private void log_func_stack_trace (
			string? log_domain,
			LogLevelFlags log_levels,
			string? message)	{
			Log.default_handler (log_domain, log_levels, message);

			/* Print a stack trace for any message at the warning level or above */
			if ((log_levels & (
				LogLevelFlags.LEVEL_WARNING |
				LogLevelFlags.LEVEL_ERROR |
				LogLevelFlags.LEVEL_CRITICAL)) != 0) {
				GLib.on_error_stack_trace ("libtool --mode=execute gdb");
			}
		}


		public void run_all(TestPlan plan) {
			plan.result.start(plan.root);
			plan.root.run(plan.result);
			plan.result.report();
		}

		public void run(Test test, TestResult result) {
			test.run(result);
		}

	}
}
