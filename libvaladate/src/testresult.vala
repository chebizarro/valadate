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

using Valadate.XmlTags;

namespace Valadate { 

	public enum TestStatus {
		NOT_RUN,
		RUNNING,
		PASSED,
		SKIPPED,
		TODO,
		ERROR,
		FAILED
	}


	public class TestResult {

		public TestConfig config {get;set;}
		public TestReportPrinter printer {get;set;}
		public int testcount {get;internal set;default=0;}

		private Queue<TestReport> reports = new Queue<TestReport>();
		private HashTable<Test, TestReport> tests = new HashTable<Test, TestReport>(direct_hash, direct_equal);

		private Regex regex;
		private const string regex_string =
			"""([<]{1}([a-z:]*){1} message="([\w\d =,-.:_&!\/;\n()]*)" """+
			"""type="[A-Z_()a-z]+"( xmlns:vdx="https:\/\/www\.valadate\.org\/vdx"){0,1}"""+
			""">[\w\d =.:,_&!\/;\n()]*<\/[a-z:]*>)+""";
			
		private static Regex regex_err;
		private const string regex_err_string =
			"""(\*{2}\n([A-Z]*):([\S]*) ([\S ]*)\n)""";

		private static int64 start_time;
		private static int64 end_time;

		public TestResult(TestConfig config) throws Error {
			this.config = config;
			if(config.in_subprocess) {
				Log.set_default_handler (log_func);
				GLib.set_printerr_handler (printerr_func);
				regex_err = new Regex(regex_err_string);
			} else {
				regex = new Regex(regex_string);
				printer = new TapTestReportPrinter(config);
			}
		}

		public bool report() {
			if (reports.is_empty())
				return false;
			
			var rpt = reports.peek_head();
			
			if (rpt.test.status == TestStatus.PASSED ||
				rpt.test.status == TestStatus.SKIPPED ||
				rpt.test.status == TestStatus.TODO ||
				rpt.test.status == TestStatus.FAILED ||
				rpt.test.status == TestStatus.ERROR) {
				
				printer.print(rpt);
				reports.pop_head();
				return report();
			}

			return true;
		}
		
		private void update_status(Test test) {
			var rept = tests.get(test);
			if(rept == null)
				return;
			rept.update_status();

			var parent = test.parent;
			if(parent == null)
				return;

			TestStatus status = TestStatus.PASSED;
			foreach(var t in parent) {
				stdout.flush();					
				if(t.status == TestStatus.RUNNING)
					return;
				else if(t.status == TestStatus.ERROR)
					status = TestStatus.ERROR;
				else if(t.status == TestStatus.FAILED)
					status = TestStatus.FAILED;
			}
			parent.status = status;
			update_status(parent);
		}
		
		private void log_func (
			string? log_domain,
			LogLevelFlags log_levels,
			string? message)	{

			var levels = (log_levels & LogLevelFlags.LEVEL_MASK).to_string().split("_");
			var level = levels[levels.length-1];
			var escaped = Markup.escape_text(message);
			var message_parts = escaped.split(":");
			var tag = ERROR_TAG;
			
			if (((log_levels & LogLevelFlags.LEVEL_INFO) != 0) ||
				((log_levels & LogLevelFlags.LEVEL_MESSAGE) != 0) ||
				((log_levels & LogLevelFlags.LEVEL_DEBUG) != 0)) {
				tag = VDX_TAG;
			} else {
				emit_timer();
			}
			
			stderr.printf("<%s message=\"%s\" type=\"%s\">\n", tag, escaped, level);
			stderr.printf("%s: %s\n", level, message_parts[message_parts.length-1]);
			stderr.printf("File: %s\n", message_parts[0]);
			stderr.printf("Line: %s\n", message_parts[1]);
			stderr.printf("</%s>\n", tag);
		}

		private static void printerr_func (string? text) {
			if(text == null)
				return;

			MatchInfo info;
			if(regex_err.match(text, 0, out info)) {
				var escaped = Markup.escape_text(info.fetch(4));
				var message_parts = info.fetch(3).split(":");
				stderr.printf("<%s message=\"%s\" type=\"%s\">\n", FAILURE_TAG, escaped, info.fetch(2));
				stderr.printf("%s: %s\n", info.fetch(2), info.fetch(4));
				/*
				stderr.printf("File: %s\n", message_parts[0]);
				stderr.printf("Line: %s\n", message_parts[1]);
				stderr.printf("Method: %s\n", message_parts[2]);
				*/
				stderr.printf("</%s>\n", FAILURE_TAG);
				emit_timer();
				stderr.printf("%s%s",TESTCASE_END, ROOT_END);
			}
		}

		public void add_test(Test test) {
			if(config.in_subprocess && test is TestAdapter) {
				stderr.printf("%s%s",XML_DECL,ROOT_START);
				stderr.printf(TESTCASE_START,test.parent.get_type().name(), test.label);
				start_time = get_monotonic_time();
				return;
			}
			if(test.status == TestStatus.NOT_RUN)
				test.status = TestStatus.RUNNING;
			reports.push_tail(new TestReport(test));
			tests.insert(test, reports.peek_tail());
		}

		public void add_error(Test test, string error) {
			if(config.in_subprocess) {
				emit_message(ERROR_TAG, error);
			} else if (test.status != TestStatus.SKIPPED &&
				test.status != TestStatus.TODO ) {
				test.status = TestStatus.ERROR;
				test.status_message = error;
				tests.get(test).update_status();
				update_status(test);
			}
		}

		public void add_failure(Test test, string failure) {
			if(config.in_subprocess) {
				emit_message(FAILURE_TAG, failure);
			} else if (test.status != TestStatus.SKIPPED &&
				test.status != TestStatus.TODO ) {
				test.status = TestStatus.FAILED;
				test.status_message = failure;
				update_status(test);
			}
		}
		
		public void add_success(Test test) {
			if(config.in_subprocess) {
				emit_timer();
				stderr.printf("%s%s",TESTCASE_END, ROOT_END);
			} else if (test.status == TestStatus.RUNNING) {
				test.status = TestStatus.PASSED;
				update_status(test);
			}
		}

		public void add_skip(Test test, string message) {
			test.status = TestStatus.SKIPPED;
			test.status_message = message;
			if(config.in_subprocess)
				stderr.printf("%s\n", SKIPPED_XML);
		}

		private static void emit_timer() {
			end_time = get_monotonic_time();
			//var ms = "%I64d".printf((end_time-start_time)/1000);
			var ms = "%f".printf((double)(end_time-start_time));
			stderr.printf(MESSAGE_XML, VDX_TIMER, ms, "TIMER", ms, VDX_TIMER);
			
		}
		
		private void emit_message(string tag, string message, string? ns = null) {
			//var domain = e.domain.to_string().up().replace("-","_");
			stderr.printf(MESSAGE_XML, tag, message, tag.up(), message, tag);
		}

		public void process_buffers(Test test, Assembly assembly) throws Error {
			
			var rept = tests.get(test);
			if(rept == null)
				return;

			uint8 buffer[4096] = {};
			assembly.stderr.read_all(buffer, null);
			
			var xml = ((string)buffer).strip();
			if(xml.length < 8)
				return;
			
			rept.xml = new XmlFile.from_string(((string)buffer).strip());

			var bits = rept.xml.eval("//testcase/text()");

			if(bits.size != 0) {
				Xml.Node* textnode = bits[0];
				rept.add_text(textnode->get_content(), SYSTEM_ERR_TAG);
				textnode->unlink();
			}

			bits = rept.xml.eval("//timer");
			Xml.Node* timer = bits[0];
			test.time = double.parse(timer->get_content());

			update_status(test);

			uint8 outbuffer[4096] = {};
			assembly.stdout.read_all(outbuffer, null);
			xml = ((string)outbuffer).strip();
			if(xml.length < 1 || xml == "\n")
				return;

			rept.add_text(xml, SYSTEM_OUT_TAG);
		
			/*
			InputStream[] inputs = { assembly.stderr, assembly.stdout };
		
			foreach(var input in inputs) {
				if(input == null)
					continue;

				uint8 buffer[4096] = {};
				input.read_all(buffer, null);
				//stdout.printf("%s\n",(string)buffer);
				MatchInfo info;
				bool nextinfo = regex.match((string)buffer, 0, out info);
				
				int[] matches = {0};
				
				while(nextinfo) {
					var res = info.fetch(2);
					var mess = info.fetch(0);
					switch(res) {
						case FAILURE_TAG:
							add_failure(test,info.fetch(3));
							break;
						case ERROR_TAG:
							add_error(test,info.fetch(3));
							break;
						case VDX_TIMER:
							test.time = double.parse(info.fetch(3));
							update_status(test);
							break;
						default:
							break;
					}
					rept.add_xml(mess);
					int start, end;
					if(info.fetch_pos(0, out start, out end)) {
						matches += start;
						matches += end;
					}
					nextinfo = info.next();
				}

				matches += buffer.length-1;
				var std_xml = "<%s>%s</%s>";
				var tag = (input == assembly.stderr) ? SYSTEM_ERR_TAG : SYSTEM_OUT_TAG;
				for(int i=0;i<matches.length;i++) {
					var start = matches[i];
					var end = matches[i+1];
					var str = buffer[start:end-start];
					if(str != "\n".data && str.length > 0)
						stdout.printf("@@%s@@\n",(string)str);
					i++;
					//rept.add_xml(std_xml.printf(tag, xml, tag));
				}
			}*/
		}
	}
}
