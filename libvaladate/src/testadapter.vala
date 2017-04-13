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


	private class TestAdapter : Object, Test {

		public string name {get;set;}
		public string label {get;set;}
		public double time {get;set;}

		public TestStatus status {get;set;default=TestStatus.NOT_RUN;}
		public string status_message {get;set;}

		public int count {
			get {
				return 1;
			}
		}

		public int size {
			get {
				return 1;
			}
		}

		private TestCase.TestMethod test;
		public Test? parent {get;set;}


		public new Test get(int index) {
			return this;
		}

		public TestAdapter(string name) {
			this.name = name;
		}

		public void add_test(owned TestPlan.TestMethod testmethod) {
			this.test = () => {
				try {
					testmethod(parent as TestCase);
				} catch (Error e) {
					throw e;
				}
			};
		}

		public void add_test_method(owned TestCase.TestMethod testmethod) {
			this.test = (owned)testmethod;
		}

		public void run(TestResult result) {
			if(status == TestStatus.SKIPPED)
				return;
			var p = parent as TestCase;
			result.add_test(this);
			p.set_up();
			try {
				test();
			} catch (Error e) {
				result.add_failure(this, e.message);
			}
			p.tear_down();
			result.add_success(this);
		}
	}
}
