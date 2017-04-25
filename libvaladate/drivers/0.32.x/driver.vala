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
 
namespace Valadate.Drivers {

	public class Driver : Object, VapiDriver {
		
		private Vala.CodeContext context;
		
		public Driver() {
			setup_context();
		}

		public void load_test_plan(VapiTestPlan plan) throws Error {
			context.add_source_file (new Vala.SourceFile (
				context, Vala.SourceFileType.PACKAGE, plan.plan.get_path()));
			var parser = new Vala.Parser ();
			parser.parse (context);
			var gatherer = new ClassGatherer(plan.assembly);
			context.accept(gatherer);
			var visitor = new TestVisitor(plan, gatherer);
			context.accept(visitor);
		}

		private void setup_context() {
			context = new Vala.CodeContext ();
			Vala.CodeContext.push (context);
			context.report.enable_warnings = false;
			context.report.set_verbose_errors (false);
			context.verbose_mode = false;
		}

	}

	
	public class ClassGatherer : Vala.CodeVisitor {
		
		public HashTable<Type, Vala.Class> classes = 
			new HashTable<Type, Vala.Class>(direct_hash, direct_equal);
		
		public Type config = typeof(TestConfig);
		public Type runner = typeof(AsyncTestRunner);
	
		private TestAssembly assembly;
	
		public ClassGatherer(TestAssembly assembly) {
			this.assembly = assembly;
		}
	
		public override void visit_namespace(Vala.Namespace ns) {
			ns.accept_children(this);
		}
		
		public override void visit_class(Vala.Class cls) {
			try {
				var classtype = find_type(cls);
				if (classtype.is_a(typeof(TestConfig)) && !classtype.is_abstract())
					config = classtype;
				else if (classtype.is_a(typeof(TestRunner)) && !classtype.is_abstract())
					runner = classtype;
				else
					classes.insert(classtype, cls);
			} catch (Error e) {
				warning(e.message);
			}
			cls.accept_children(this);
		}
		
		private Type find_type(Vala.Class cls) throws Error {
			var attr = new Vala.CCodeAttribute (cls);
			unowned TestPlan.GetType node_get_type =
				(TestPlan.GetType)assembly.get_method(
					"%sget_type".printf(attr.lower_case_prefix));
			var ctype = node_get_type();
			return ctype;
		}

	}
	
	public class TestVisitor : Vala.CodeVisitor {
		public TestPlan plan {get;set;}
		internal delegate TestCase Constructor(); 
		
		private TestSuite testsuite;
		private TestCase testcase;
		private ClassGatherer gatherer;

		public TestVisitor(TestPlan plan, ClassGatherer gatherer) throws Error {
			this.plan = plan;
			this.gatherer = gatherer;
			visit_config();
			plan.result = new TestResult(plan.config);
			visit_test_runner();
		}

		private void visit_config() {
			plan.config = Object.new(gatherer.config, "options", plan.options) as TestConfig;
		}

		public void visit_test_runner() {
			TestRunner.register_default(gatherer.runner);
			plan.runner = TestRunner.new(plan.config);
		}

		public override void visit_namespace(Vala.Namespace ns) {
			if (ns.name != null) {
				var currpath = "/" + ns.get_full_name().replace(".","/");
				if(plan.config.in_subprocess)
					if(!plan.options.running_test.has_prefix(currpath))
						return;

				if(currpath.last_index_of("/") == 0)
					testsuite = plan.root;

				var ts = new TestSuite(ns.name);
				testsuite.add_test(ts);
				testsuite = ts;
			}
			ns.accept_children(this);
		}
		
		public override void visit_class(Vala.Class cls) {

			try {
				if (is_subtype_of(cls, typeof(TestCase)) && !cls.is_abstract) {
					unowned Constructor ctor = get_constructor(cls);
					testcase = ctor();
					testcase.name = cls.name;
					testcase.label = "/%s".printf(cls.get_full_name().replace(".","/"));
					testsuite.add_test(testcase);
					visit_testcase(cls);

				} else if (is_subtype_of(cls,typeof(TestSuite))) {
					visit_testsuite(cls);
				}
			} catch (Error e) {
				error(e.message);
			}
			cls.accept_children(this);
		}

		private bool is_subtype_of(Vala.Class cls, Type type) {
			var t = Type.from_name(cls.get_full_name().replace(".",""));
			if(t.is_a(type))
				return true;
			return false;
		}

		private unowned Constructor get_constructor(Vala.Class cls) throws Error {
			var attr = new Vala.CCodeAttribute (cls.default_construction_method);
			return (Constructor)plan.assembly.get_method(attr.name);
		}

		public void visit_testcase(Vala.Class cls)  {

			var t = Type.from_name(cls.get_full_name().replace(".",""));
			var p = t.parent();
			if(p != typeof(TestCase)) {
				var basecls = gatherer.classes.get(p);
				if(basecls != null)
					visit_testcase(basecls);
			}

			foreach(var method in cls.get_methods()) {

				if(plan.config.in_subprocess)
					if (plan.options.running_test != "%s/%s".printf(
						testcase.label, method.name))
						continue;

				if(!is_test(method))
					continue;

				var added = false;
				foreach(var test in testcase)
					if(test.name == method.name)
						added=true;
				if(added)
					continue;

				var adapter = new TestAdapter(method.name, plan.config.timeout);
				annotate_label(adapter);
				annotate(adapter, method);

				if(plan.config.in_subprocess && adapter.status != TestStatus.SKIPPED) {
					var attr = new Vala.CCodeAttribute (method);

					if(method.coroutine) {
						try {
							unowned TestPlan.AsyncTestMethod beginmethod = 
								(TestPlan.AsyncTestMethod)plan.assembly.get_method(attr.name);
							unowned TestPlan.AsyncTestMethodResult testmethod = 
								(TestPlan.AsyncTestMethodResult)plan.assembly.get_method(attr.finish_real_name);
							adapter.add_async_test(beginmethod, testmethod);
						} catch (Error e) {
							var message = e.message;
							adapter.add_test_method(()=> {debug(message);});
						}
					} else {
						try {
							TestPlan.TestMethod testmethod =
								(TestPlan.TestMethod)plan.assembly.get_method(attr.name);
							adapter.add_test((owned)testmethod);
						} catch (Error e) {
							var message = e.message;
							adapter.add_test_method(()=> {debug(message);});
						}
					}
				} else {
					adapter.add_test_method(()=> {assert_not_reached();});
				}

				adapter.label = "%s/%s".printf(
					testcase.label,
					adapter.label);

				testcase.add_test(adapter);
			}

		}

		private void annotate_label(Test test) {
			if(test.name.has_prefix("test_")) {
				test.label = test.name.substring(5);
			} else if(test.name.has_prefix("_test_")) {
				test.label = test.name.substring(6);
				test.status = TestStatus.SKIPPED;
			} else if(test.name.has_prefix("todo_test_")) {
				test.label = test.name.substring(10);
				test.status = TestStatus.TODO;
			} else {
				test.label = test.name;
			}
			test.label = test.label.replace("_", " ");
		}

		private void annotate(TestAdapter adapter, Vala.Method method) {

			foreach(var attr in method.attributes) {
				if(attr.name == "Test") {
					if(attr.has_argument("name"))
						adapter.label = attr.get_string("name");
					if(attr.has_argument("skip")) {
						adapter.status = TestStatus.SKIPPED;
						adapter.status_message = attr.get_string("skip");
					} else if(attr.has_argument("todo")) {
						adapter.status = TestStatus.SKIPPED;
						adapter.status_message = attr.get_string("todo");
					} else if(attr.has_argument("timeout")) {
						adapter.timeout = int.parse(attr.get_string("timeout"));
					}
				}
			}
		}

		private bool is_test(Vala.Method method) {
			bool istest = false;
			
			if(method.is_virtual)
				foreach(var test in testcase)
					if(test.name == method.name)
						return false;
			
			if (method.name.has_prefix("test_") ||
				method.name.has_prefix("_test_") ||
				method.name.has_prefix("todo_test_"))
				istest = true;

			foreach(var attr in method.attributes)
				if(attr.name == "Test")
					istest = true;

			if(method.has_result)
				istest = false;
			
			if(method.get_parameters().size > 0)
				istest = false;
				
			return istest;
		}

		public TestSuite visit_testsuite(Vala.Class testclass) throws Error {
			unowned Constructor meth = get_constructor(testclass); 
			var testcase_test = meth() as TestSuite;
			testcase_test.name = testclass.name;
			return testcase_test;
		}	
	}
}
