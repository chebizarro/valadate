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

namespace Valadate.Introspection {

	using Valadate.Framework;

	public class Module : Object {
		
		private string lib_path;
		private GLib.Module module;

		public Module (string libpath) {
			lib_path = libpath;
		} 
		
		public void load_module() throws Error
			requires(lib_path != null)
		{
			if (!File.new_for_path(lib_path).query_exists())
				throw new Error.MODULE("Module: %s does not exist", lib_path);
			
			module = GLib.Module.open (lib_path, ModuleFlags.BIND_LOCAL);
			if (module == null)
				throw new Error.MODULE(GLib.Module.error());
			module.make_resident();
		}
		
		internal void* get_method(string method_name) throws Error {
			void* function;
			if(module.symbol (method_name, out function))
				if (function != null)
					return function;
			throw new Error.METHOD(GLib.Module.error());
		}

		
	}

}
