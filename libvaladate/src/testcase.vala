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
		
		public virtual void run(TestResult result) {
			result.add_test_start(this);
			_tests.foreach((t) => {
				t.run(result);
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
			debug("SKIP %s", message);
		}

		public void fail(string? message = null) {
			critical("FAIL %s", message ?? "");
		}

		public virtual void set_up() {}

		public virtual void tear_down() {}

		public virtual void assert(bool expr) {
			
		}

		public virtual void assert_not_reached() {
			
		}

		public virtual void assert_null(void* expr) {
			
		}

	

		private class TestAdaptor : Object, Test {

			[CCode (cname = "fmemopen")]
			private extern static FileStream memopen(void* buffer, size_t size, string mode);

			private TestMethod test;
			private TestCase testcase;

			public string name {get;set;}
			public string label { get; set; }

			public int count {
				get {
					return 1;
				}
			}
			
			public new Test get(int index) {
				return this;
			}

			private TestResult result;
			private bool skipped = false;
			
			public TestAdaptor(string name, owned TestMethod test, TestCase testcase) {
				this.test = (owned)test;
				this.name = name;
				this.testcase = testcase;
			}

			public void run(TestResult result) {
				this.result = result;
				Log.set_default_handler (log_func);

				//debug("Running %s [%s]", name, label);
				var oldstdout = (owned)stdout;
				char buffer[4096] = { }; 
				var buf = memopen(buffer, sizeof(uint8)*4096, "w");
				stdout = (owned)buf;
				
				result.add_test(this);
				this.testcase.set_up();
				this.test();
				this.testcase.tear_down();
				if(!skipped)
					result.add_success(this, (string)buffer);
				stdout = (owned)oldstdout;
			}

			private void log_func (
				string? log_domain,
				LogLevelFlags log_levels,
				string? message)	{

				Log.default_handler (log_domain, log_levels, message);

				/* Print a stack trace for any message at the warning level or above */
				if ((log_levels & (
					LogLevelFlags.LEVEL_WARNING |
					LogLevelFlags.LEVEL_ERROR |
					LogLevelFlags.LEVEL_CRITICAL)) != 0) {

					result.add_failure(this, message);

					//GLib.on_error_stack_trace ("libtool --mode=execute gdb");

				}
				if ((log_levels & (LogLevelFlags.LEVEL_INFO)) != 0) {
					if(message.has_prefix("SKIP "))
						result.add_skip(this, message.substring(5), "");

					//GLib.on_error_stack_trace ("libtool --mode=execute gdb");

				}
			}

		}
	}
}
