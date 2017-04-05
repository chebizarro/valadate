/* 
 * Valadate - Unit testing library for GObject-based libraries.
 *
 * testcase.vala
 * Copyright (C) 2016-2017 Chris Daley
 * Copyright (C) 2009-2012 Julien Peeters
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
 * 	Julien Peeters <contact@julienpeeters.fr>
 */


namespace Valadate {

	[CCode (cheader_filename="testcase.h")]
	public abstract class TestCase : Object, Test, TestFixture {

		/**
		 * The TestMethod delegate represents a {@link Valadate.Test} method
		 * that can be added to a TestCase and run
		 */
		public delegate void TestMethod ();

		/**
		 * the name of the TestCase
		 */
		public string name { get; set; }

		/**
		 * the label of the TestCase
		 */
		public string label { get; set; }

		/**
		 * Returns the number of {@link Valadate.Test}s that will be run by this TestCase
		 */
		public int count {
			get {
				int testcount = 0;
				_tests.foreach((t) => {
					testcount += t.count;
				});
				return testcount;
			}
		}

		public bool skipped {get;set;default=false;}

		public bool failed {get;set;default=false;}

		public string bug_base {get;set;}
		
		private List<Test> _tests = new List<Test>();

		public new Test get(int index) {
			return _tests.nth_data((uint)index);
		}

		public new void set(int index, Test test) {
			_tests.insert_before(_tests.nth(index), test);
			var t = _tests.nth_data((uint)index++);
			_tests.remove(t);
		}

		public void add_test(string testname, owned TestMethod test, string? label = null) {
			var adaptor = new TestAdaptor (testname, (owned)test, this);
			adaptor.label = label;
			_tests.append(adaptor);
		}
		
		
		private Test current_test;
		private TestResult current_result;
		
		public virtual void run(TestResult result) {
			current_result = result;
			result.add_test_start(this);
			
			_tests.foreach((t) => {
				current_test = t;
				if(failed && !result.config.keep_going)
					return;
				result.add_test(t);
				t.run(result);
				failed = t.failed;
			});
			result.add_test_end(this);
		}

		public void bug(string reference)
			requires(bug_base != null)
		{
			stdout.printf("MSG: Bug Reference: %s%s",bug_base, reference);
			stdout.flush();
		}

		public void skip(string message) {
			current_test.skipped = true;
			current_result.add_skip(current_test, "SKIP: " + message, "");
		}

		public void fail(string? message = null) {
			current_test.failed = true;
			current_result.add_failure(current_test, "FAIL: " + message ?? "");
		}

		public extern void assert(bool expr);

		//[CCode (cname = "_valadate_assert", cheader_filename="asserts.h")]
		//public extern void assert_true(bool expr);

		//[CCode (cname = "_valadate_assert", cheader_filename="asserts.h")]
		//public extern void assert_not_null(void* expr);

		//[CCode (cname = "_valadate_assert", cheader_filename="asserts.h")]
		//public extern void assert_not_reached();

		protected void assertion_message_expr(
			string? domain, string file, int line, string func, string? expr) {
			string s;
			if(expr == null)
				s = "code should not be reached";
			else
				s = "assertion failed: (%s)".printf(expr);
			assertion_message(domain, file, line, func, s);
		}

		protected void assertion_message(
			string? domain, string file, int line, string func, string message) {
			var mess = "FAIL: %s:%d: %s".printf(Path.get_basename(file),line,message);

			current_test.failed = true;
			current_result.add_failure(current_test, mess);
		}

		public virtual void set_up() {}

		public virtual void tear_down() {}

		private class TestAdaptor : Object, Test {

			[CCode (cname = "fmemopen")]
			private extern static FileStream memopen(void* buffer, size_t size, string mode);

			private TestMethod test;
			private TestCase testcase;

			public string name {get;set;}
			public string label { get; set; }
			public bool skipped {get;set;default=false;}
			public bool failed {get;set;default=false;}

			public int count {
				get {
					return 1;
				}
			}
			
			public new Test get(int index) {
				return this;
			}

			public TestAdaptor(string name, owned TestMethod test, TestCase testcase) {
				this.test = (owned)test;
				this.name = name;
				this.testcase = testcase;
			}

			public void run(TestResult result) {
				this.result = result;

				/*
				var log = Log.set_handler(null,
					LogLevelFlags.FLAG_FATAL |
					LogLevelFlags.FLAG_RECURSION |
					LogLevelFlags.LEVEL_ERROR,
					log_err_func);

				Log.set_always_fatal(
					LogLevelFlags.FLAG_FATAL |
					LogLevelFlags.FLAG_RECURSION |
					LogLevelFlags.LEVEL_ERROR);

				var oldstderr = (owned)stderr;
				char buffer[4096] = { }; 
				var buf = memopen(buffer, sizeof(uint8)*4096, "w");
				stderr = (owned)buf;
				*/
				sthis = this;
				GLib.set_printerr_handler (printerr_func);
				this.testcase.set_up();
				this.test();
				this.testcase.tear_down();
				if(!skipped && !failed)
					result.add_success(this, ""); //(string)buffer);
				
				/*
				stderr = (owned)oldstderr;
				Log.remove_handler(null, log);
				*/
			}

			private static TestResult result;
			private static Test sthis;

			private static void printerr_func (string? text) {
				if (text == null || str_equal (text, ""))
					return;
				var fields = text.split(":");
				result.add_error(sthis, "FAIL: %s: %s:%s:%s:%s:%s".printf(
					fields[0].substring(3), Path.get_basename(fields[1]), fields[2],
					sthis.name, fields[4], fields[5]
				));
				result.report();
				/* Print a stack trace since we've hit some major issue */
				GLib.on_error_stack_trace ("libtool --mode=execute gdb");
			}


			private void log_func (
				string? log_domain,
				LogLevelFlags log_levels,
				string? message)	{


				/* Print a stack trace for any message at the warning level or above */
				if ((log_levels & (
					LogLevelFlags.LEVEL_WARNING |
					LogLevelFlags.LEVEL_CRITICAL)) != 0) {
					//GLib.on_error_stack_trace ("libtool --mode=execute gdb");
					result.add_failure(this, message);
					result.report();
					//return;

				} else if ((log_levels &
					(LogLevelFlags.LEVEL_ERROR)) != 0) {
					result.add_error(this, message);
					result.report();
					return;
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
}
