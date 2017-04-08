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

					if(!plan.config.in_subprocess && !plan.config.list_only) {

						result.add_test_start(subtest);

						run_test_internal(subtest, result, testpath);

						result.add_test_end(subtest);


					} else {

						run_test_internal(subtest, result, testpath);

					}

				} else if (subtest is TestSuite) {

					run_test_internal(subtest, result, testpath);

					if(!plan.config.in_subprocess) {
						/*
						var rpt = new TestReport(subtest, TestStatus.PASSED,-1);
						rpt.report.connect((s)=> ((TestSuite)subtest).tear_down());
						reports.push_tail(rpt);
						*/
					}

				} else if (plan.config.list_only) {
					
					stdout.printf("%s\n", labelpath);

				} else if (plan.config.in_subprocess) {

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
					if(test.status == TestStatus.RUNNING)
						test.status = TestStatus.PASSED;

					//result.process_buffer(test, buffer);

				}

			} catch (Error e) {

				test.status = TestStatus.FAILED;
				test.status_message = e.message;

				//result.add_error(test, e.message);


			} finally {
				_n_ongoing_tests--;
				var wrapper = _pending_tests.pop_head ();
				if(wrapper != null)
					wrapper.cb();
			}
		}

	}
}
