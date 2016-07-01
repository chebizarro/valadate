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

namespace Valadate.Introspection.Repository {
	
	private static bool initialized = false;
	private static Module[] modules;
	private static HashTable<string, Class> classes;
	private static Repository[] repositories;
	
	private static void initialize() {
		if (!initialized) {
			modules = {};
			repositories = {};
			classes = new HashTable<string, Class>(str_hash, str_equal);
			initialized = true;
		}
	}

	[Version (experimental = true, experimental_until = "")]
	public static Class[] get_class_by_type(GLib.Type type) {
		Class[] result = {};
		classes.foreach((k, c)=> {
			if (c.class_type.is_a(type))
				result += c;
		});
		return result;
	}

	[Version (experimental = true, experimental_until = "")]
	public static Class get_class_by_name(string name) {
		unowned Class result = classes.lookup(name);
		return result;
	}


	[Version (experimental = true, experimental_until = "")]
	public static void add_package(string modpath, string girpath) throws Error {
		initialize();
		var module = new Module(modpath);
		module.load_module();
		var repo = load_gir(girpath);
		repo.module = module;
		modules += module;
		repositories += repo;
	}

	private static Repository load_gir(string girpath) throws Error {
		if (!File.new_for_path(girpath).query_exists())
			throw new Error.GIR("Gir: %s does not exist", girpath);
		var output = parse_gir(girpath);
		try {
			return Json.gobject_from_data(typeof(Repository), output) as Repository;
		} catch (GLib.Error e) {
			throw new Error.GIR(e.message);
		}
	}

	private static string parse_gir(string girpath) throws Error {
		var gir = Xml.Parser.parse_file (girpath);
		if (gir == null)
			throw new Error.GIR("Gir for %s not found", girpath);
			
		/*
		File xslfile = File.new_for_uri("resource:///org/valadate/lib/data/gir.xsl");
		
		if(!xslfile.query_exists())
			throw new Error.PARSER("Gir parser not found");
		
		uint8[] contents;
		try {
			xslfile.load_contents (null, out contents, null);
		} catch (GLib.Error e) {
			throw new Error.PARSER(e.message);
		}
		*/
		var xsl = Xml.Parser.parse_doc(GIR_PARSER);
		if (xsl == null)
			throw new Error.PARSER("Gir parser corrupted");
		
		var stylesheet = Xslt.parse_stylesheet_doc(xsl);
		if(stylesheet == null)
			throw new Error.PARSER("Gir parser corrupted");
		
		var result = stylesheet->apply(gir, {});
		if(result == null)
			throw new Error.PARSER("Gir parser corrupted");
		
		string output;
		int length;
		int res = stylesheet->save_result_to_string(out output, out length, result);
		if(result == null)
			throw new Error.PARSER("Gir parser corrupted");

		delete gir;
		delete xsl;
		delete result;
		return output;
	}

		
	
	internal class Repository : Object, Json.Serializable {
		
		public class Include : Object {
			public string name {get;set;}
			public string version {get;set;}
		}

		public class Package : Object {
			public string name {get;set;}
		}
		
		internal Include include {get;set;}

		public Package package {get;set;}
		public Include[] includes {get;set;} 
		public Namespace namespace {get;set;}

		public weak Module module {get;set;}

		/**
		 * Json.Serializable interface implementation
		 */
		public virtual Json.Node serialize_property (string property_name, GLib.Value value, GLib.ParamSpec pspec) {
			return default_serialize_property (property_name, value, pspec);
		}

		public virtual bool deserialize_property (string property_name, out GLib.Value value, GLib.ParamSpec pspec, Json.Node property_node) {
			if (property_name == "include") {
				Include[] incl = {};
				var array = property_node.get_array();
				array.foreach_element ((a,i,n) => {
					incl += Json.gobject_deserialize(typeof(Include), n) as Include;
				});
				includes = incl;
				value.init_from_instance(incl[0]);
			} else if (property_name == "package")
				value.init_from_instance(Json.gobject_deserialize(typeof(Package), property_node) as Package);
			else if (property_name == "namespace") {
				var ns = Json.gobject_deserialize(typeof(Namespace), property_node) as Namespace;
				ns.repository = this;
				value.init_from_instance(ns);
			} else
				return default_deserialize_property (property_name, value, pspec, property_node);
			return true;
		}

		public unowned GLib.ParamSpec find_property (string name) {
			GLib.Type type = this.get_type();
			GLib.ObjectClass ocl = (GLib.ObjectClass)type.class_ref();
			unowned GLib.ParamSpec? spec = ocl.find_property (name); 
			return spec;
		}
		
	}


}
