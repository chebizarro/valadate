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

#if MACOSX
	const string TESTEXE = "tests_PIE-0";
#else
	const string TESTEXE = "lt-tests_PIE-0";
#endif

	public class TestLoadPIE : TestCase {
		
		[Test (name="load_pie")]
		public void load_pie () {
			var modname = Config.VALADATE_TESTS_DIR + "/PIE/.libs/" + TESTEXE;
			var mod = GLib.Module.open (modname, ModuleFlags.BIND_LOCAL);
			assert (mod != null);
		}
		
		[Test (name="has_test_method")]
		public void has_test_method() {
			var modname = Config.VALADATE_TESTS_DIR + "/PIE/.libs/" + TESTEXE;
			var mod = GLib.Module.open (modname, ModuleFlags.BIND_LOCAL);
			void* function;
			assert(mod.symbol ("valadate_tests_test_pie_test_pie_fail", out function));
			assert(function != null);
		}
	}
	
}
