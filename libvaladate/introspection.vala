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

[ CCode ( gir_version = "1.0", gir_namespace = "Valadate") ]
namespace Valadate.Introspection {

	public errordomain Error {
		MODULE,
		GIR,
		TESTS,
		METHOD
	}

	private Module[] modules;

	private Class[] classes;

	public static Module[] get_modules() {
		return modules;
	}

	public static void add_repository(string libpath, string girpath) throws Error {
		if (modules == null)
			modules = {};

		Module module = new Module(libpath, girpath);
		module.load_module();
		module.load_gir();
		modules += module;
	}

	public static Class get_class_info(Type type) {
		return null;
	}
	

	public class TypeInfo : Object {
		public string name {get;internal set;}
		
	}


	public class Class : Object {
		public string name {get;internal set;}
		public string type_name {get;internal set;}
		public string type_struct {get;internal set;}
		public string parent {get;internal set;}
		public Method constructor {get;internal set;}
		//public Method[] methods {get;internal set;}
		//internal Method method {get;set;}

	}
	
	public class Method : Object {
		public string name {get;internal set;}
		public string identifier {get;internal set;}
		public Parameter return_value {get;internal set;}
		
	}
	
	public class Field : Object {
		
	}
	
	
	public class Parameter : Object {
		public string transfer_ownership {get;internal set;}
		
		
	}

	public class Annotation : Object {
		public string key {get;internal set;}
		public string value {get;internal set;}
	}


	internal class Namespace : Object, Json.Serializable {
		public string name {get;internal set;}
		public string version {get;internal set;}
		public string prefix {get;internal set;}
		internal Annotation annotation {get;set;}
		public Annotation[] annotations {get;internal set;}
		internal Class class {get;set;}
		public Class[] classes {get;internal set;}

		/*
		static T[] deserialize_array<T>(out GLib.Value value, Json.Node node) {
			var node_array = node.get_array();
			var new_array = new T[node_array.get_length()];
			int i =0;
			node_array.foreach_element ((a,i,n) => {
				new_array[i] = (T)Json.gobject_deserialize(typeof(T), n);
				i++;
			});
			value.init_from_instance(new_array[0]);
			return new_array;
		}
*/
		/**
		 * Json.Serializable interface implementation
		 */
		public virtual Json.Node serialize_property (string property_name, GLib.Value value, GLib.ParamSpec pspec) {
			return default_serialize_property (property_name, value, pspec);
		}

		public virtual bool deserialize_property (string property_name, out GLib.Value value, GLib.ParamSpec pspec, Json.Node property_node) {
			message(property_name);

			if (pspec.value_type == typeof(string)) {
				value.init(typeof(string));
				value.set_string(property_node.get_string());
				return true;
			}
			
			if (property_name == "annotation") {
				Annotation[] incl = {};
				var array = property_node.get_array();
				array.foreach_element ((a,i,n) => {
					incl += Json.gobject_deserialize(typeof(Annotation), n) as Annotation;
				});
				annotations = incl;
				value.init_from_instance(incl[0]);
				return true;
			}

			if (property_name == "class") {
				//classes = deserialize_array(out value, property_node);
				//return true;
				Class[] incl = {};
				var array = property_node.get_array();
				array.foreach_element ((a,i,n) => {
					incl += Json.gobject_deserialize(typeof(Class), n) as Class;
				});
				classes = incl;
				value.init_from_instance(incl[0]);
				return true;
			}
			
			return default_deserialize_property (property_name, value, pspec, property_node);
		}

		public unowned GLib.ParamSpec find_property (string name) {
			message(name);
			GLib.Type type = this.get_type();
			GLib.ObjectClass ocl = (GLib.ObjectClass)type.class_ref();
			unowned GLib.ParamSpec? spec;
			if (name == "annotation")
				spec = ocl.find_property ("annotations"); 
			else
				spec = ocl.find_property (name); 
			return spec;
		}		
	}

	public class Repository : Object, Json.Serializable {
		
		public class Include : Object {
			public string name {get;set;}
			public string version {get;set;}
		}

		public class Package : Object {
			public string name {get;set;}
		}
		
		internal Include include {get;set;}

		public Package package {get;internal set;}
		public Include[] includes {get;internal set;} 
		internal Namespace namespace {get;internal set;}

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
				return true;
			}
			
			if (property_name == "package") {
				value.init_from_instance(Json.gobject_deserialize(typeof(Package), property_node) as Package);
				return true;
			}
			
			if (property_name == "namespace") {
				value.init_from_instance(Json.gobject_deserialize(typeof(Namespace), property_node) as Namespace);
				return true;
			}
		
			return default_deserialize_property (property_name, value, pspec, property_node);
		}

		public unowned GLib.ParamSpec find_property (string name) {
			GLib.Type type = this.get_type();
			GLib.ObjectClass ocl = (GLib.ObjectClass)type.class_ref();
			unowned GLib.ParamSpec? spec = ocl.find_property (name); 
			return spec;
		}
		
	}


}
