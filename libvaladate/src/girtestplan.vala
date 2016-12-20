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

	public class GIRTestPlan : Object, TestPlan {

		internal delegate Type GetType(); 
		internal delegate void TestMethod(TestCase self);

		private Xml.XPath.Context;
		private TestSuite testsuite;
		private TestCase testcase;
		private Module module;
		
		private string binary;
		private string? running;

		public GIRTestPlan(string binary, TestSuite root, string? running = null) {
			this.binary = binary;
			this.testsuite = root;
			this.running = running;
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
				setup_context(testplanfile);
				parse();
			} catch (ModuleError e) {
				throw new ConfigError.MODULE(e.message);
			}
		}


		private void setup_context(string file) throws ConfigError {
			var doc = Xml.Parser.parse_file (file);
			if (doc == null)
				throw new ConfigError.TESTPLAN("There was an error parsing the Test Plan at %s", testplanfile);

			context = new Xml.XPath.Context (doc);
			context.register_ns("xmlns", "http://www.gtk.org/introspection/core/1.0");
			context.register_ns("c", "http://www.gtk.org/introspection/c/1.0");
			context.register_ns("glib", "http://www.gtk.org/introspection/glib/1.0");
		}
		
		public void parse() throws ConfigError {
			visit_root();
		}

		public void visit_root() {
			Xml.XPath.Object* res = cntx.eval_expression ("//xmlns:namespace");

			for (int i = 0; i < res->nodesetval->length (); i++) {
				Xml.Node* node = res->nodesetval->item (i);
				
				var tsname = node->get_prop("name");
				var ts = new TestSuite(tsname);
				testsuite.add_test(ts);
				testsuite = ts;
				
				visit_testsuite(node);
				
			}
			delete res;
			
		}
		
		public void visit_testsuite(Xml.Node* suitenode) {
			var expression = "%s/xmlns:class/xmlns:implements[@name='ValadateTest']/::parent".printf(suitenode->get_path());
			Xml.XPath.Object* res = cntx.eval_expression (expression);

			for (int i = 0; i < res->nodesetval->length (); i++) {
				Xml.Node* node = res->nodesetval->item (i);
				
				string node_type_str = node->get_prop("get-type");
				GetType node_get_type = (GetType)module.get_method(node_type_str);
				var node_type = node_get_type();

				if(!node_type.is_a(typeof(Valadate.Test)))
					return;

				var testname = node.get_prop("name");
				var test = GLib.Object.new(node_type, "name", tsname) as Test;
				testsuite.add_test(test);

				if(node_type.is_a(typeof(TestSuite))) {
					testsuite = test as TestSuite;
					//visit_testsuite(node);
				} else if (node_type.is_a(typeof(TestCase))) {
					testcase = test as TestCase;
					visit_testcase(node);
				}
				
			}
			
		}
		
		public void visit_testcase(Xml.Node* casenode) {
			var expression = "%s/xmlns:method".printf(casenode->get_path());
			Xml.XPath.Object* res = cntx.eval_expression (expression);

			for (int i = 0; i < res->nodesetval->length (); i++) {
				Xml.Node* node = res->nodesetval->item (i);

				var method_name = node->get_prop("name");
				
				// get signature
				// get annotations
				
				if(method_name.has_prefix("test_")) {

					unowned TestMethod testmethod = null;
					var method_cname = node->get_prop("identifier");
					testmethod = (TestMethod)module.get_method(method_cname);

					if (testmethod != null) {
						testcase.add_test(method_name, ()=> {
							testmethod(current_test);
						});
					}
					
				}

			}
			
		}
		

		
	}

}
