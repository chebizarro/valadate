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

	static int main (string[] args) {
		load_pie();
		return 0;
		
	}

	
	public void load_pie () {
		
		var modname = Config.VALADATE_TESTS_DIR + "/PIE/tests_PIE";
		var mod = Module.open (modname, ModuleFlags.BIND_LOCAL);

		if (mod == null) {
			stdout.printf ("Could not load module: %s\n", modname);
		} else {
			stdout.printf ("Loaded module: %s\n", modname);
			mod.make_resident ();
		}

		/*
		void* function;
		if (!mod.symbol ("vala_plugin_register", out function) || function == null) {
			stdout.printf ("Could not load entry point for module %s\n", path);
			continue;
		}*/

	}
	
	
}
