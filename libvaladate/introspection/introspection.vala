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
		
		public string name {get;internal set;}

		private Type _class_type;

		public Type class_type {get {
			if(_class_type == GLib.Type.INVALID)
				init_class_type();
			return _class_type;
		}}

		internal Repository.ClassDef classdef {get;set;}

		internal Module module {get{return classdef.module;}}

		internal Class.from_class_def(Repository.ClassDef def) {
			name = def.name;
			classdef = def;
		}

		private void init_class_type() {
			unowned GetClassType meth = (GetClassType)module.get_method(classdef.get_type_method);
			_class_type = meth();
		}

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


}
