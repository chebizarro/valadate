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
	
	
	public class TestPIE : TestCase {
		
		public TestPIE() {
			base("PIE Tests");
		}
		
		
		[Test (name="/valadate/tests/testpie")]
		public void test_pie () {
			
			
			
		}
		
	}

	public void load_pie (string dirname) {
		Dir dir;
		try {
			dir = Dir.open (dirname, 0);
		} catch (Error e) {
			return;
		}
		
		string? name = null;

		while ((name = dir.read_name ()) != null) {
			string path = Path.build_filename (dirname, name);
			if (FileUtils.test (path, FileTest.IS_DIR)) {
				continue;
			}
			if (!name.has_prefix ("valaplugin")) {
				continue;
			}

			var mod = Module.open (path, ModuleFlags.BIND_LOCAL);

			if (mod == null) {
				if (verbose_mode) {
					stdout.printf ("Could not load module: %s\n", path);
				}
				continue;
			} else {
				if (verbose_mode) {
					stdout.printf ("Loaded module: %s\n", path);
				}
			}

			void* function;
			if (!mod.symbol ("vala_plugin_register", out function) || function == null) {
				if (verbose_mode) {
					stdout.printf ("Could not load entry point for module %s\n", path);
				}
				continue;
			}

			unowned RegisterPluginFunction register_plugin = (RegisterPluginFunction) function;
			register_plugin (this);

			mod.make_resident ();
		}
	}
	
	
	static int main (string[] args) {
		message ("Test");
		return 1;
		
	}
	
	
	
}
