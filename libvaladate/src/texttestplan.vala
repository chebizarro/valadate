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

	public class TextTestPlan : Object, TestPlan {

		public TestAssembly assembly {get;construct set;}
		public TestOptions options {get;protected set;}
		public TestConfig config {get;protected set;}
		public TestResult result {get;protected set;}
		public TestRunner runner {get;protected set;}
		public TestSuite root {get;protected set;}
		public File plan {get;construct set;}

		private TestSuite testsuite;
		private TestCase testcase;
		private string currpath;
		
		private string[] content;
		private Type runner_type = typeof(AsyncTestRunner);
		private Type config_type = typeof(TestConfig);
		
		private HashTable<string, Type> typemap =
			new HashTable<string, Type>(str_hash, str_equal);
		
		construct {
			try {
				options = assembly.options;
				testsuite = root = new TestSuite("/");
				load();
			} catch (Error e) {
				error(e.message);
			}
		}

		private void load() throws Error {
			uint8[] cont;
			plan.load_contents(null, out cont, null);
			content = ((string)cont).split("\n");
			visit_classes();
		}
		
		private void visit_classes() throws Error {
			foreach(var line in content) {
				if(line.has_suffix("_get_type")) {
					unowned TestPlan.GetType node_get_type =
						(TestPlan.GetType)assembly.get_method(line);
					var node_type = node_get_type();
					if(node_type.is_a(typeof(TestCase)))
						visit_testcase(node_type, line.substring(0, line.length-9));
					else if(node_type.is_a(typeof(TestRunner)))
						runner_type = node_type;
					else if(node_type.is_a(typeof(TestConfig)))
						config_type = node_type;
				}
			}
		}

		private void visit_testcase(Type type, string name) {
			
		}

		public int run() throws Error {
			return runner.run_all(this);
		}
		
	}

}
