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

	public class GirTestPlan : Object, TestPlan {

		public TestAssembly assembly {get;construct set;}
		public TestOptions options {get;set;}
		public TestConfig config {get;set;}
		public TestResult result {get;set;}
		public TestRunner runner {get;set;}
		public TestSuite root {get;protected set;}
		public File plan {get;construct set;}

		internal delegate Type GetType(); 

		private TestSuite testsuite;
		private TestCase testcase;
		private string currpath;
		
		private XmlFile xmlfile; 

		construct {
			try {
				options = assembly.options;
				testsuite = root = new TestSuite("/");
				load();
			} catch (Error e) {
				error(e.message);
			}
		}

		private void load() throws ConfigError {
			setup_context();
			visit_config();
			visit_test_result();
			visit_test_runner();
			visit_root();
		}

		private void setup_context() throws ConfigError {
			try {
				xmlfile = new XmlFile(plan);
				xmlfile.register_ns("xmlns", "http://www.gtk.org/introspection/core/1.0");
				xmlfile.register_ns("c", "http://www.gtk.org/introspection/c/1.0");
				xmlfile.register_ns("glib", "http://www.gtk.org/introspection/glib/1.0");
			} catch (Error e) {
				throw new ConfigError.TESTPLAN(e.message);
			}
		}

		private void visit_config() {
			Type ctype = find_type("//xmlns:class[@parent='ValadateTestConfig']");
			if(ctype == Type.INVALID)
				ctype = typeof(TestConfig);
			config = Object.new(ctype, "options", options, null) as TestConfig;
		}

		private void visit_test_result() {
			//Type ctype = find_type("//xmlns:class[@parent='ValadateTestResult']");
			//if(ctype == Type.INVALID)
				//ctype = typeof(TapTestResult);
			result = new TestResult(config);
		}
		
		private void visit_test_runner() {
			Type ctype = find_type("//xmlns:class[@implements='ValadateTestRunner']");
			if(ctype != Type.INVALID)
				TestRunner.register_default(ctype);
			runner = TestRunner.new(config);
		}

		private Type find_type(string xpath) {
			var res = xmlfile.eval(xpath);
			Type ctype = Type.INVALID;
			if(res.size == 1) {
				Xml.Node* node = res[0];
				string node_type_str = node->get_prop("get-type");
				unowned GetType node_get_type = (GetType)assembly.get_method(node_type_str);
				ctype = node_get_type();
			}
			return ctype;
		}

		private void visit_root() {
			var ns = xmlfile.eval("//xmlns:namespace");
			
			foreach (Xml.Node* node in ns) {
				var tsname = node->get_prop("prefix");
				if(options.running_test != null)
					if(tsname != options.running_test.split("/")[1])
						continue;
				currpath = "/" + tsname;
				var ts = new TestSuite(tsname);
				testsuite.add_test(ts);
				testsuite = ts;
				visit_testsuite(node);
			}
		}
		
		private void visit_testsuite(Xml.Node* suitenode) {
			var expression = "%s/xmlns:class".printf(suitenode->get_path());
			var res = xmlfile.eval (expression);

			foreach (Xml.Node* node in res) {
				string node_type_str = node->get_prop("get-type");
				unowned GetType node_get_type = (GetType)assembly.get_method(node_type_str);
				var node_type = node_get_type();

				if(!node_type.is_a(typeof(Valadate.Test)) || node_type.is_abstract())
					continue;

				var testname = node->get_prop("name");
				
				if(options.running_test != null)
					if(testname != options.running_test.split("/")[2])
						continue;

				var oldpath = currpath;
				currpath += "/" + testname;
				var test = GLib.Object.new(node_type, "name", testname, "label", currpath) as Test;
				testsuite.add_test(test);

				if(node_type.is_a(typeof(TestSuite))) {
					testsuite = test as TestSuite;
					//visit_testsuite(node);
				} else if (node_type.is_a(typeof(TestCase))) {
					testcase = test as TestCase;
					visit_class(node_type);
				}
				currpath = oldpath;
			}
		}
		
		private void visit_class(Type classtype)
			requires(classtype.is_a(typeof(Test)))
		{
			if(classtype == typeof(TestCase))
				return;

			var expression = "//xmlns:class[@glib:type-name='%s']/xmlns:method".printf(classtype.name());
			var res = xmlfile.eval(expression);
			
			foreach (Xml.Node* method in res) {

				string name = method->get_prop("name");
				if(config.in_subprocess && name != options.running_test.split("/")[3])
					continue;
				if(!is_test(method))
					continue;

				var adapter = new TestAdapter(name);
				annotate_label(adapter);
				annotate(adapter, method->children);

				if(config.in_subprocess && adapter.status != TestStatus.SKIPPED) {
					var method_cname = method->get_prop("identifier");
					TestPlan.TestMethod testmethod = (TestPlan.TestMethod)assembly.get_method(method_cname);
					if(testmethod != null)
						adapter.add_test((owned)testmethod);
				} else {
					adapter.add_test_method(()=> {assert_not_reached();});
				}
				adapter.label = "%s/%s".printf(currpath, adapter.label);
				testcase.add_test(adapter);
			}
			visit_class(classtype.parent());
		}

		private void annotate_label(Test test) {
			if(test.name.has_prefix("test_")) {
				test.label = test.name.substring(5);
			} else if(test.name.has_prefix("_test_")) {
				test.label = test.name.substring(6);
				test.status = TestStatus.SKIPPED;
			} else if(test.name.has_prefix("_todo_test_")) {
				test.label = test.name.substring(11);
				test.status = TestStatus.TODO;
			} else {
				test.label = test.name;
			}
			test.label = test.label.replace("_", " ");
		}

		/**
		 * Annotates a TestAdapter based on the attributes in the Xml.Node*
		 */
		private void annotate(TestAdapter adapter, Xml.Node* node) {
			while(node != null) {
				if(node->name == "annotation" || node->name == "attribute") {
					var attname = node->get_prop("name") ?? node->get_prop("key");
					if(attname == "test.name")
						adapter.label = node->get_prop("value");
					if(attname == "test.skip") {
						adapter.status = TestStatus.SKIPPED;
						adapter.status_message = node->get_prop("value");
					}
					if(attname == "test.todo") {
						adapter.status = TestStatus.TODO;
						adapter.status_message = node->get_prop("value");
					}
				}
				node = node->next;
			}
		}
		/**
		 * Tests if the Xml.Node* points to a TestMethod
		 */
		private bool is_test(Xml.Node* node) {
			bool istest = false;
			string name = node->get_prop("name");
			
			if(name.has_prefix("test_") || name.has_prefix("_test_"))
				istest = true;
			
			var child = node->children;
			while(child != null) {
				if(child->name == "annotation" || child->name == "attribute") {
					var attname = child->get_prop("name") ?? child->get_prop("key");
					if(attname.has_prefix("test."))
						istest = true;
				}
				if(child->name == "return-value") {
					var retchild = child->children;
					while(retchild->name != "type") { retchild = retchild->next; };
					if(retchild->get_prop("name") != "none")
						istest = false;
				}
				if(child->name == "parameters")
					istest = false;
				child = child->next;
			}
			return istest;
		}
		
		public void run() {
			runner.run_all(this);
		}
		
	}

}
