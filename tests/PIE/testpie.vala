/*
 * Valadate - Unit testing library for GObject-based libraries.
 * Copyright (C) 20016  Chris Daley <chebizarro@gmail.com>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published
 * by the Free Software Foundation, either version 3 of the License, or (at
 * your option) any later version.
 *
 * This program is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
 * or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Lesser General Public
 * License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
 
namespace Valadate.Tests {
	
	
	public class TestPIE : TestCase {
		/*
		public TestPIE() {
			//base("PIE");
			add_test("test_pie_fail", test_pie_fail);
			add_test("test_pie_pass", test_pie_pass);
		}*/
		
		[Test (name="test_pie_fail")]
		public void test_pie_fail () {
			assert_true(true);
		}

		[Test (name="test_pie_pass")]
		public void test_pie_pass () {
			assert_true(true);
		}
		
	}
	
	/*
	static void main (string[] args) {
		GLib.Test.init (ref args);
		GLib.TestSuite.get_root ().add_suite (new TestPIE().suite);
		GLib.Test.run ();
	}*/
	
	
}
