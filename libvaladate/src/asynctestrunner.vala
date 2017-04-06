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
			result.start(test);
			test.run(result);
			result.report();
		}


		public void run_all(TestPlan plan) {

			Environment.set_variable("G_MESSAGES_DEBUG", "all", true);

			if(!plan.config.keep_going) {
				Environment.set_variable("G_DEBUG","fatal-criticals fatal-warnings gc-friendly", true);
				Environment.set_variable("G_SLICE","always-malloc debug-blocks", true);
			}


			this.plan = plan;

			plan.result.start(plan.root);
			run_test_internal(plan.root, plan.result, "");

			if (plan.config.running_test == null) {
				loop = new MainLoop();
				var time = new TimeoutSource (15);
				time.set_callback (() => {
					var res = plan.result.report();
					if(!res)
						loop.quit();
					return res;
					
				});
				time.attach (loop.get_context ());
				loop.run();
			}

		}

		public void run_test(Test test, TestResult result) {
			test.run(result);
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

					if(plan.config.running_test == testpath) {
						test.run(result);
						result.report();
					}
				} else {

					subtest.name = testpath;
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
					result.process_buffer(test, buffer);
				}

			} catch (Error e) {
				result.add_error(test, e.message);
				result.process_buffer(test, buffer);

			} finally {
				
				if(test.passed || test.skipped || plan.config.keep_going) {
					_n_ongoing_tests--;
					var wrapper = _pending_tests.pop_head ();
					if(wrapper != null)
						wrapper.cb();
				} else {
					_n_ongoing_tests = 0;
					_pending_tests.clear();
				}
			}
		}

		private void process_buffer(Test test, TestResult result, string buffer, bool failed = false) {
			string skip = null;
			string err = null;
			string pass = null;
			string[] message = {};
			
			foreach(string line in buffer.split("\n")) {
				if(line.has_prefix("ok ")) {
					if("# SKIP:" in line) {
						skip = line.split("# ")[1];
					} else {
						pass = line;
					}
				} else if (line.has_prefix("# FAIL:")) {
					err = line.substring(2);
				} else {
					var mes = line.strip();
					if (mes.length > 0)
						message += mes;
				}
			}
			
			if (skip != null)
				result.add_skip(test, skip, "");
			else if(err != null)
				result.add_failure(test, string.joinv("\n",err.strip().split("\n")));
			else if(pass != null)
				result.add_success(test, string.joinv("\n",message));
		}

	}
}
