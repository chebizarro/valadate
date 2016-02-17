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

	public class Module : Object {
		
		private string lib_path;
		private string gir_path;
		private GLib.Module module;

		public Module (string libpath, string girpath) {
			lib_path = libpath;
			gir_path = girpath;
		} 
		
		public void load_module() throws Error
			requires(lib_path != null)
		{
			module = GLib.Module.open (lib_path, ModuleFlags.BIND_LOCAL);
			if (module == null)
				throw new RunError.MODULE(GLib.Module.error());
			module.make_resident();
		}

		public void load_gir() throws Error
			requires(this.gir_path != null)
			requires(this.module != null)
		{

			var output = parse_gir();
			var repo = Json.gobject_from_data(typeof(Repository), output) as Repository;
			
		}

		internal string parse_gir() throws Error {
			var gir = Xml.Parser.parse_file (gir_path);
			if (gir == null)
				throw new RunError.GIR("Gir for %s not found", gir_path);
				
			File xslfile = File.new_for_uri("resource:///org/valadate/lib/data/gir.xsl");
			uint8[] contents;
			xslfile.load_contents (null, out contents, null);
			var xsl = Xml.Parser.parse_doc((string)contents);

			var stylesheet = Xslt.parse_stylesheet_doc(xsl);
			var result = stylesheet->apply(gir, {});
			string output;
			int length;
			int res = stylesheet->save_result_to_string(out output, out length, result);
			delete gir;
			delete xsl;
			delete result;
			
			return output;
		}
		
	}

}
