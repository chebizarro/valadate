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

	public class Module : TypeModule {
		
		private static string search_path;

		public static void load_all() {
			
			
		}

		[CCode (has_target = false)]
		private delegate Type PluginInitFunc (TypeModule module);

		private GLib.Module module = null;

		private string name = null;
		
		public Module (string name) {
			this.name = name;
		}
		
		public override bool load () {
			string path = GLib.Module.build_path (null, name);
			module = GLib.Module.open (path, GLib.ModuleFlags.BIND_LAZY);
			if (null == module) {
				error ("Module not found");
			}
		
			void* plugin_init = null;
			if (!module.symbol ("module_init", out plugin_init)) {
				error ("No such symbol");
			}
			
			((PluginInitFunc) plugin_init) (this);
			
			return true;
		}
		
		public override void unload () {
			module = null;
			message ("Library unloaded");
		}
	}


}
