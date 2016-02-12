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
 
namespace Valadate {

	public class TestLoadPIE : TestCase {
		
		public delegate void test_method();
		
		public TestLoadPIE() {
			//base("Load PIE Tests");
			//add_test("Load PIE", load_pie);
			//add_test("Has Test Method", has_test_method);
		}

		[Test (name="load_pie")]
		public void load_pie () {
			var modname = Config.VALADATE_TESTS_DIR + "/PIE/.libs/lt-tests_PIE";
			var mod = Module.open (modname, ModuleFlags.BIND_LOCAL);
			assert (mod != null);
		}
		
		[Test (name="has_test_method")]
		public void has_test_method() {
			var modname = Config.VALADATE_TESTS_DIR + "/PIE/.libs/lt-tests_PIE";
			var mod = Module.open (modname, ModuleFlags.BIND_LOCAL);
			void* function;
			assert(mod.symbol ("valadate_test_pie_test_pie_fail", out function));
			assert(function != null);
			((test_method)function)();
		}
	}

/*
	static void main (string[] args) {
		GLib.Test.init (ref args);
		GLib.TestSuite.get_root ().add_suite (new TestLoadPIE().suite);
		GLib.Test.run ();
	}
*/	
	
}
