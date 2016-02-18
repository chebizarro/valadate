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


	internal class ClassDef : Object, Json.Serializable {
		public string name {get;internal set;}
		public string type_name {get;internal set;}
		public string type_struct {get;internal set;}
		public string parent {get;internal set;}
		public Method constructor {get;internal set;}
		public Method[] methods {get;internal set;}
		public Method method {get;set;}

		public string get_type_method {get;set;}
		
		public weak Namespace namespace {get;set;}
		public weak Module module {get { return namespace.module; }}

		public virtual Json.Node serialize_property (string property_name, GLib.Value value, GLib.ParamSpec pspec) {
			return default_serialize_property (property_name, value, pspec);
		}

		public virtual bool deserialize_property (string property_name, out GLib.Value value, GLib.ParamSpec pspec, Json.Node property_node) {

			if (pspec.value_type == typeof(string)) {
				value.init(typeof(string));
				value.set_string(property_node.get_string());
			} else if (property_name == "constructor") {
				value.init_from_instance(Json.gobject_deserialize(typeof(Method), property_node) as Method);
			} else if (property_name == "method") {
				Method[] incl = {};
				var array = property_node.get_array();
				array.foreach_element ((a,i,n) => {
					incl += Json.gobject_deserialize(typeof(Method), n) as Method;
				});
				methods = incl;
				value.init_from_instance(incl[0]);
			} else {
				return default_deserialize_property (property_name, value, pspec, property_node);
			}
			return true;
		}

		public unowned GLib.ParamSpec find_property (string name) {
			GLib.Type type = this.get_type();
			GLib.ObjectClass ocl = (GLib.ObjectClass)type.class_ref();
			if(name == "get-type")			
				return ocl.find_property ("get-type-method"); 
			return ocl.find_property (name); 
		}		

	}


	internal class Namespace : Object, Json.Serializable {
		public string name {get;internal set;}
		public string version {get;internal set;}
		public string prefix {get;internal set;}
		internal Annotation annotation {get;set;}
		public Annotation[] annotations {get;internal set;}
		internal ClassDef class {get;set;}
		public weak Repository repository {get;set;}
		public weak Module module {get { return repository.module; }}

		/**
		 * Json.Serializable interface implementation
		 */
		public virtual Json.Node serialize_property (string property_name, GLib.Value value, GLib.ParamSpec pspec) {
			return default_serialize_property (property_name, value, pspec);
		}

		public virtual bool deserialize_property (string property_name, out GLib.Value value, GLib.ParamSpec pspec, Json.Node property_node) {

			if (pspec.value_type == typeof(string)) {
				value.init(typeof(string));
				value.set_string(property_node.get_string());
			} else if (property_name == "annotation") {
				Annotation[] incl = {};
				var array = property_node.get_array();
				array.foreach_element ((a,i,n) => {
					incl += Json.gobject_deserialize(typeof(Annotation), n) as Annotation;
				});
				annotations = incl;
				value.init_from_instance(incl[0]);
			} else if (property_name == "class") {
				var array = property_node.get_array();
				array.foreach_element ((a,i,n) => {
					var cls = Json.gobject_deserialize(typeof(ClassDef), n) as ClassDef;
					if(cls != null) {
						if(!classes.contains(cls.name)) {
							cls.namespace = this;
							var class = new Class.from_class_def(cls);
							classes.insert(class.name, class);
						}
					}
				});
				value.init(typeof(ClassDef));
			} else {
				return default_deserialize_property (property_name, value, pspec, property_node);
			}
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
