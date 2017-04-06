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
		public delegate void TestMethod () throws Error;
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

		private Test current_test;
		private TestResult current_result;

		public new Test get(int index) {
			return _tests.nth_data((uint)index);
		}

		public new void set(int index, Test test) {
			_tests.insert_before(_tests.nth(index), test);
			var t = _tests.nth_data((uint)index++);
			_tests.remove(t);
		}

		public void add_test(Test test) {
			_tests.append(adaptor);
		}

		public void add_test_method(string testname, owned TestMethod test, string? label = null) {
			var adaptor = new TestAdaptor (testname, (owned)test, this);
			adaptor.label = label;
			_tests.append(adaptor);
		}
		
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
	}
}
