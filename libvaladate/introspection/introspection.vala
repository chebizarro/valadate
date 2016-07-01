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

	public errordomain Error {
		MODULE,
		GIR,
		PARSER,
		TESTS,
		METHOD
	}


	public class TypeInfo : Object {
		public string name {get;internal set;}
		
	}


	public class Class : Object {
		
		internal delegate Type GetClassType(); 
		internal delegate void* Constructor(); 
		
		public string name {get;internal set;}

		public bool abstract {get{return classdef.abstract;}}

		private Type _class_type;

		public Type class_type {get {
			if(_class_type == GLib.Type.INVALID)
				init_class_type();
			return _class_type;
		}}

		internal Repository.ClassDef classdef {get;set;}

		internal weak Module module {get{return classdef.module;}}

		public Annotation[] annotations {get;internal set;}

		private Class() {}

		internal Class.from_class_def(Repository.ClassDef def) {
			name = def.name;
			classdef = def;
			annotations = def.annotations;
		}

		private void init_class_type() {
			unowned GetClassType meth = (GetClassType)module.get_method(classdef.get_type_method);
			_class_type = meth();
		}

		[Version (experimental = true, experimental_until = "")]
		public Method[] get_methods() {
			return classdef.methods;
		} 

		[Version (experimental = true, experimental_until = "")]
		public void* get_method(string methodname) {
			return module.get_method(methodname);
		}

		[Version (experimental = true, experimental_until = "")]
		public void* get_instance() {
			unowned Constructor meth = (Constructor)module.get_method(classdef.constructor.identifier);
			return meth();
		}

	}
	
	public class Method : Object {
		public string name {get;internal set;}
		public string identifier {get;internal set;}
		public Parameter return_value {get;internal set;}
		internal weak Repository.ClassDef class {get;set;}
		
		public Parameter[] parameters {get;internal set;}
		
		internal weak Module module {get{return class.module;}}

		public Annotation[] annotations {get;internal set;}
		
		[CCode ( has_target = "false" )]
		internal delegate void* Method(void* object, ...);
		
		[Version (experimental = true, experimental_until = "")]
		public void* call(void* object, ...) {
			unowned Method meth = (Method)module.get_method(identifier);
			return meth(object);
		}
		
		internal Method.from_def(Repository.MethodDef def) {
			name = def.name;
			identifier = def.identifier;
			return_value = def.return_value;
			annotations = def.annotations;
			foreach(var annotation in annotations)
				annotation.method = this;
			parameters = def.params;
		}
		
	}
	
	public class Field : Object {
		
	}
	
	
	public class Parameter : Object {
		public string name {get;internal set;}
		public string transfer_ownership {get;internal set;}
		
		
	}

	public class Annotation : Object {
		public string key {get;internal set;}
		public string value {get;internal set;}
		internal weak Method method {get;set;}
	}


}
