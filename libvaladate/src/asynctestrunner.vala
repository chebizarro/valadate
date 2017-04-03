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

	public class AsyncTestRunner : Object, TestRunner {

		public int testcount {get;protected set;default=0;}

		private class DelegateWrapper {
			public SourceFunc cb;
		}

		private uint _n_ongoing_tests = 0;
		private Queue<DelegateWrapper> _pending_tests = new Queue<DelegateWrapper> ();
		private Queue<TestReport> reports = new Queue<TestReport>();
		private HashTable<Test, TestReport> tests = new HashTable<Test, TestReport>(direct_hash, direct_equal);

		/* Change this to change the cap on the number of concurrent operations. */
		private static uint _max_n_ongoing_tests = 1;
		private MainLoop loop;

		private SubprocessLauncher launcher =
			new SubprocessLauncher(GLib.SubprocessFlags.STDOUT_PIPE | GLib.SubprocessFlags.STDERR_MERGE);

		private TestPlan plan;

		construct {
			_max_n_ongoing_tests = GLib.get_num_processors();
			this.launcher.setenv("G_MESSAGES_DEBUG","all", true);
			this.launcher.setenv("G_DEBUG","fatal-criticals fatal-warnings gc-friendly", true);
			this.launcher.setenv("G_SLICE","always-malloc debug-blocks", true);
			GLib.set_printerr_handler (printerr_func_stack_trace);
			Log.set_default_handler (log_func_stack_trace);
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

		public void run(Test test, TestResult result) {
			
		}


		public void run_all(TestPlan plan) {

			this.plan = plan;

			count_tests(plan.root);

			run_test_internal(plan.root, plan.result, "/");

			if (plan.config.running_test == null) {
				loop = new MainLoop();
				var time = new TimeoutSource (15);
				time.set_callback (() => {
					plan.result.report();
					return true;
				});
				time.attach (loop.get_context ());
				loop.run();
			}

		}

		public void run_test(Test test, TestResult result) {
			test.run(result);
		}

		private void count_tests(Test test) {
			if(test is TestSuite)
				foreach(var subtest in test)
					count_tests(subtest);
			else
				testcount += test.count;
		}

		private void run_test_internal(Test test, TestResult result, string path) {

			foreach(var subtest in test) {

				string labelpath = "%s/%s".printf(path, subtest.label);
				string testpath = "%s/%s".printf(path, subtest.name);

				if(subtest is TestCase) {

					if(plan.config.running_test == null && !plan.config.list_only) {

						result.add_test_start(subtest);

						run_test_internal(subtest, result, testpath);

						result.add_test_end(subtest);


					} else {

						run_test_internal(subtest, result, testpath);

					}

				} else if (subtest is TestSuite) {

					run_test_internal(subtest, result, testpath);

					if(plan.config.running_test == null) {
						/*
						var rpt = new TestReport(subtest, TestStatus.PASSED,-1);
						rpt.report.connect((s)=> ((TestSuite)subtest).tear_down());
						reports.push_tail(rpt);
						*/
					}

				} else if (plan.config.list_only) {
					
					stdout.printf("%s\n", labelpath);

				} else if (plan.config.running_test != null) {

					if(plan.config.running_test == testpath)
						subtest.run(result);

				} else {

					subtest.name = testpath;
					subtest.label = labelpath;
					
					result.add_test(subtest);
					run_async.begin(subtest, result);

				}
			}
		}

		private async void run_async(Test test, TestResult result) {
			
			string command = "%s -r %s".printf(plan.assembly.binary.get_path(), test.name);
			string[] args;
			string buffer = null;

			if (_n_ongoing_tests > _max_n_ongoing_tests) {
				var wrapper = new DelegateWrapper();
				wrapper.cb = run_async.callback;
				_pending_tests.push_tail((owned)wrapper);
				yield;
			}
		
			try {
				_n_ongoing_tests++;
				
				Shell.parse_argv(command, out args);
				var process = launcher.spawnv(args);
				yield process.communicate_utf8_async(null, null, out buffer, null);
				
				if(process.wait_check()) {
					//debug("#### %s", buffer);
					process_buffer(test, result, buffer);
				}

			} catch (Error e) {
				//debug("!!!! %s : %s", buffer, e.message);
				process_buffer(test, result, buffer, true);
			} finally {
				_n_ongoing_tests--;
				var wrapper = _pending_tests.pop_head ();
				if(wrapper != null)
					wrapper.cb();
			}
		}

		private void process_buffer(Test test, TestResult result, string buffer, bool failed = false) {
			string skip = null;
			string[] message = {};
			
			foreach(string line in buffer.split("\n"))
				if (line.has_prefix("SKIP "))
					skip = line;
				else
					message += line;
			
			if (skip != null)
				result.add_skip(test, skip, string.joinv("\n",message));
			else
				if(failed)
					result.add_failure(test, string.joinv("\n",message));
				else
					result.add_success(test, string.joinv("\n",message));
		}

	}
}
