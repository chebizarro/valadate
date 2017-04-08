/*
 * Valadate - Unit testing library for GObject-based libraries.
 * Copyright (C) 2017  Chris Daley <chebizarro@gmail.com>
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

	public class TapTestMessage : TestMessage {

		public TapTestMessage(string level, string message, string? path = null) {
			base(level, message, path);
		}

		public override string to_string() {
			
			return "";
		}

	}

	public class TapTestResult : Object, TestResult {

		public int testcount {get;internal set;default=0;}
		public TestConfig config {get;construct set;}

		private Queue<TestReport> reports = new Queue<TestReport>();
		private HashTable<Test, TestReport> tests = new HashTable<Test, TestReport>(direct_hash, direct_equal);
	
		private Regex regex;
		private const string error_regex = 
			"""^[\*]{0,2}[\s]?[a-z:0-9\(\): ]*([A-Za-z-0-9]{0,8})[\s]?""" +
			"""[\*]{0,2}:[\s]?([a-zA-Z.:0-9\/_]*)[\s]?(.+)""";

		private int testno = 0;

		construct {
			if(config.in_subprocess)
				regex = new Regex(error_regex);
		}

		public bool report() {
			if (reports.is_empty())
				return false;
			
			var rpt = reports.peek_head();

			if (rpt.test.status == TestStatus.PASSED ||
				rpt.test.status == TestStatus.SKIPPED ||
				rpt.test.status == TestStatus.STATUS ||
				rpt.test.status == TestStatus.FAILED ||
				rpt.test.status == TestStatus.ERROR) {
				
				try {
					//rpt.report(output);
				} catch (Error e) {
					stdout.printf("Bail out! %s", e.message);
					stdout.flush();
					error(e.message);
				}
				reports.pop_head();
				return report();
			}

			return true;
		}

		private void count_tests(Test test) {
			if(test is TestSuite)
				foreach(var subtest in test)
					count_tests(subtest);
			else
				testcount += test.count;
		}
		
		public void start(Test test) {
			count_tests(test);
			if(config.in_subprocess)
				return;
			var rep = new TestReport(test, -1);
			reports.push_tail(rep);
			rep.buffer = "TAP version 13\n1..%d\n# random seed: %s\n".printf(
				testcount, config.seed);
		}

		/*
		public void add_error(Test test, string error) {
			//update_test(test, TestStatus.ERROR, error);
		}

		public void add_failure(Test test, string failure) {
			//update_test(test, TestStatus.FAILED, failure);
		}

		public void add_success(Test test, string? message = null) {
			//update_test(test, TestStatus.PASSED, message);
		}
		
		public void add_skip(Test test, string message) {
			//update_test(test, TestStatus.SKIPPED, message);
		}*/

		public void add_test(Test test) {
			reports.push_tail(new TestReport(test, ++testno));
			tests.insert(test, reports.peek_tail());
		}

		public void add_test_start(Test test) {
			if(config.in_subprocess)
				return;
			var rep = new TestReport(test, -1);
			reports.push_tail(rep);
			rep.buffer = "# Start of %s tests\n".printf(test.label);
		}

		public void add_test_end(Test test) {

			if(config.in_subprocess)
				return;

			var rep = new TestReport(test, -1);
			reports.push_tail(rep);
			rep.buffer = "# End of %s tests\n".printf(test.label);

		}

		/*
		private void update_test(Test test, TestStatus status, string? message) {

			var rept = tests.get(test);
			if(rept == null)
				return;
			rept.status = status;
			//rept.message = message.printf(rept.index);

		}*/

		public void process_buffer(Test test, string buffer) {
			
			var rept = tests.get(test);
			if(rept == null)
				return;

			string[] lines = buffer.split("\n");
			string[] output = {};

			for(int i=0; i<lines.length; i++) {

				var line = lines[i];
				MatchInfo info;

				if(regex.match(line, 0, out info)) {
					var message = new TapTestMessage(
						info.fetch(1),info.fetch(2),info.fetch(3));

					var level = info.fetch(1);
					switch(level) {
						case "WARNING":
						case "CRITICAL":
						case "ERROR":
							rept.status = TestStatus.FAILED;
							rept.error = message;
							break;
						case "Message":
						case "DEBUG":
						case "INFO":
							rept.messages.append(message);
							break;
						default:
							rept.buffer += "# %s\n".printf(line);
							break;
					}
				} else if (line.has_prefix("Child process killed by signal")) {
					rept.error = new TapTestMessage("ERROR", line);
					rept.status = TestStatus.FAILED;
				} else if (line == "Aborted (core dumped)") {
					rept.error = new TapTestMessage("ERROR", line);
					rept.status = TestStatus.FAILED;
				} else if (line == "" && i == lines.length-1) {
					// skip this line entirely
				} else if (line.has_prefix("#")) {
					rept.buffer += "%s\n".printf(line);
				} else {
					rept.buffer += "# %s\n".printf(line);
				}
			}
		}
		
	}
}
