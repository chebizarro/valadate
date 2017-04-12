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
		private VapiTestPlan plan;
		private File file;
		
		public void load_test_plan(File file, VapiTestPlan plan) {
			this.file = file;
			setup_context();
			
			context.add_source_file (new Vala.SourceFile (context, Vala.SourceFileType.PACKAGE, file.get_path()));
			var parser = new Vala.Parser ();
			parser.parse (context);
			var visitor = new TestVisitor(plan);
			context.accept(visitor);
			plan.config = visitor.get_config();
			plan.result = visitor.get_result();
			plan.runner = visitor.get_runner();
		}

		private void setup_context() {
			context = new Vala.CodeContext ();
			Vala.CodeContext.push (context);
			context.report.enable_warnings = false;
			context.report.set_verbose_errors (false);
			context.verbose_mode = false;
		}

		
	}

	
	public class TestVisitor : Vala.CodeVisitor {
		public TestPlan plan {get;set;}
		internal delegate void* Constructor(); 
		
		private Type[] _config = {};
		private Type[] _result = {};
		private Type[] _runner = {};
		
		private TestSuite testsuite;

		public TestVisitor(TestPlan plan) {
			this.plan = plan;
		}

		public TestRunner get_runner() {
			if(_runner.length == 1)
				TestRunner.register_default(_runner[0]);
			return TestRunner.new(plan.config);
		}

		public TestConfig get_config() {
			Type ctype = typeof(TestConfig);
			if(_config.length == 1)
				ctype = (_config[0] != Type.INVALID) ? _config[0] : ctype;
			return Object.new(ctype, "options", plan.options) as TestConfig;
		}

		public TestResult get_result() {
			Type rtype = typeof(TestResult);
			if(_result.length == 1)
				rtype = (_result[0] != Type.INVALID) ? _result[0] : rtype;
			return Object.new(rtype, "config", plan.config) as TestResult;
		}

		public override void visit_namespace(Vala.Namespace ns) {

			if (ns.name != null) {
				var currpath = "/" + ns.get_full_name();
				if(plan.options.running_test != null)
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
		
		public override void visit_class(Vala.Class @class) {
			
			try {
				if (is_subtype_of(@class, "Valadate.TestCase"))
					testsuite.add_test(visit_testcase(@class));
				
				else if (is_subtype_of(@class, "Valadate.TestSuite"))			
					testsuite.add_test(visit_testsuite(@class));

				else if (is_subtype_of(@class, "Valadate.TestRunner"))			
					_runner += get_class_type(@class);

				else if (is_subtype_of(@class, "Valadate.TestConfig"))			
					_config += get_class_type(@class);

				else if (is_subtype_of(@class, "Valadate.TestResult"))			
					_result += get_class_type(@class);

			} catch (Error e) {
				error(e.message);
			}
			class.accept_children(this);
		}

		private bool is_subtype_of(Vala.Class @class, string typename) {
			foreach(var basetype in @class.get_base_types())
				if(((Vala.UnresolvedType)basetype).to_qualified_string() == typename)
					return true;
			return false;
		}

		private Type get_class_type(Vala.Class @class) {
			var attr = new Vala.CCodeAttribute (@class);
			return Type.from_name(attr.name);
		}

		private unowned Constructor get_constructor(Vala.Class @class) {
			var attr = new Vala.CCodeAttribute (@class.default_construction_method);
			return (Constructor)plan.assembly.get_method(attr.name);
		}

		public TestCase visit_testcase(Vala.Class testclass)  {
			
			unowned Constructor meth = get_constructor(testclass); 
			var testcase_test = meth() as TestCase;		
			testcase_test.name = testclass.name;
			
			foreach(var method in testclass.get_methods()) {
				if( method.name.has_prefix("test_") &&
					method.has_result != true &&
					method.get_parameters().size == 0) {

					if (plan.options.running_test != null &&
						plan.options.running_test != "/" + method.get_full_name().replace(".","/"))
						continue;

					unowned TestPlan.TestMethod testmethod = null;
					var attr = new Vala.CCodeAttribute(method);
					testmethod = (TestPlan.TestMethod)plan.assembly.get_method(attr.name);

					if (testmethod != null) {
						//testcase_test.add_test_method(testmethod);
					}
				}
			}
			return testcase_test;
		}

		public TestSuite visit_testsuite(Vala.Class testclass)  {
			unowned Constructor meth = get_constructor(testclass); 
			var testcase_test = meth() as TestSuite;
			testcase_test.name = testclass.name;
			return testcase_test;
		}
		
	}


}

public static Type vala_driver_register_type(Module module) {
	return typeof(Valadate.Drivers.Driver);
}


