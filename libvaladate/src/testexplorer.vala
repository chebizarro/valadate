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
 
	internal class TestExplorer : Vala.CodeVisitor {

		internal delegate void* Constructor(); 
		internal delegate void TestMethod(TestCase self);

		private TestSuite current;
		private Module module;
		private TestPlan testplan;
		private string binary;
		private string? running;
		
		public TestExplorer(string binary, TestSuite root) {
			this.binary = binary;
			this.current = root;
			this.running = Valadate.get_current_test_path();
		}

		public void load() throws ConfigError {
			string testdir = Path.get_dirname(binary).replace(".libs", "");
			
			string tplan = Path.get_basename(binary);
			if(tplan.has_prefix("lt-"))
				tplan = tplan.substring(3);
			
			string testplanfile = testdir + GLib.Path.DIR_SEPARATOR_S + tplan + ".gir";
			
			if (!FileUtils.test (testplanfile, FileTest.EXISTS))
				throw new ConfigError.TESTPLAN("Test Plan %s Not Found!", testplanfile);
			
			try {
				module = new Module(binary);
				module.load_module();
				testplan = new TestPlan();
				testplan.parse(testplanfile);
				testplan.accept(this);
				
			} catch (ModuleError e) {
				throw new ConfigError.MODULE(e.message);
			}
		}
		

		public override void visit_class(Vala.Class class) {
			
			try {
				if (is_subtype_of(class, "Valadate.TestCase") &&
					class.is_abstract != true)
					current.add_test(visit_testcase(class));
				
				else if (is_subtype_of(class, "Valadate.TestSuite") &&
					class.is_abstract != true)			
					current.add_test(visit_testsuite(class));

			} catch (ModuleError e) {
				error(e.message);
			}
			class.accept_children(this);
		}

		private bool is_subtype_of(Vala.Class class, string typename) {
			foreach(var basetype in class.get_base_types())
				if(((Vala.UnresolvedType)basetype).to_qualified_string() == typename)
					return true;
			return false;
		}

		private unowned Constructor get_constructor(Vala.Class class) throws ModuleError {
			var attr = new Vala.CCodeAttribute (class.default_construction_method);
			return (Constructor)module.get_method(attr.name);
		}

		public TestCase visit_testcase(Vala.Class testclass) throws ModuleError {
			
			unowned Constructor meth = get_constructor(testclass); 
			var current_test = meth() as TestCase;		
			current_test.name = testclass.name;
			
			foreach(var method in testclass.get_methods()) {
				if( method.name.has_prefix("test_") &&
					method.has_result != true &&
					method.get_parameters().size == 0) {

					if (running != null &&
						running != "/" + method.get_full_name().replace(".","/"))
						continue;

					unowned TestMethod testmethod = null;
					var attr = new Vala.CCodeAttribute(method);
					testmethod = (TestMethod)module.get_method(attr.name);

					if (testmethod != null) {
						current_test.add_test(method.name, ()=> {
							testmethod(current_test);
						});
					}
				}
			}
			return current_test;
		}

		public TestSuite visit_testsuite(Vala.Class testclass) throws ModuleError {
			unowned Constructor meth = get_constructor(testclass); 
			var current_test = meth() as TestSuite;
			current_test.name = testclass.name;
			return current_test;
		}

		public override void visit_namespace(Vala.Namespace ns) {

			if (ns.name != null) {
				var testsuite = new TestSuite(ns.name);
				current.add_test(testsuite);
				current = testsuite;
			}
			ns.accept_children(this);
		}
	}
}
