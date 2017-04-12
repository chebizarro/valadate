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

	public class TestAssembly : Assembly {
	
		public TestOptions options {get;set;}

		private GLib.Module module;
		
		public TestAssembly(string[] args) throws Error {
			base(File.new_for_path(args[0]));
			options = new TestOptions(args);
		}
		
		private TestAssembly.copy(TestAssembly other) throws Error {
			base(other.binary);
			options = other.options;
		}
		
		public override Assembly clone() throws Error {
			return new TestAssembly.copy(this);
		}

		private void load_module() throws AssemblyError {
			module = GLib.Module.open (binary.get_path(), ModuleFlags.BIND_LAZY);
			if (module == null)
				throw new AssemblyError.LOAD(GLib.Module.error());
			module.make_resident();
		}
		
		public void* get_method(string method_name) throws AssemblyError {
			if(module == null)
				load_module();
			void* function;
			if(module.symbol (method_name, out function))
				if (function != null)
					return function;
			throw new AssemblyError.METHOD(GLib.Module.error());
		}
	
	}
}
