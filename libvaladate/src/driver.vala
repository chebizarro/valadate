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

	public interface VapiDriver : Object {
		
		[CCode (has_target = false)]
		private delegate Type RegisterDriverFunction (Module module);
		
		public static VapiDriver @new(string version) {
			
			var driverfile = File.new_for_path(
				Path.build_filename(
					Config.VALADATE_DRIVER_DIR,
					version + ".x", ".libs", "driver.so"));
			
			var module = Module.open (driverfile.get_path(), ModuleFlags.BIND_LAZY);
			
			void* loader;
			module.symbol("vala_driver_register_type", out loader);
			
			RegisterDriverFunction method = (RegisterDriverFunction)loader;
			
			Type t = method(module);
			
			return Object.new(t) as VapiDriver;
		}
		
		
		public abstract void load_test_plan(VapiTestPlan plan);
		
	}

}
