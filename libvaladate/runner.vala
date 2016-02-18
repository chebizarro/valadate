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

namespace Valadate.Framework {

	public errordomain RunError {
		MODULE,
		GIR,
		TESTS,
		METHOD
	}

	public class TextRunner : Object, TestRunner {
		
		public delegate Object CreateTestObject();
		public delegate void TestMethod(TestCase self);
		
		private Module module;
		private string path;
		private Test[] _tests;
		private Xml.Doc* gir;
		
		public Test[] tests {
			get {
				return _tests;
			}
		}
		
		public TextRunner(string path) {
			this.path = path;
		}
		
		~TextRunner() {
			delete gir;
		}
		
		public void load() throws RunError {
			try {
				load_module();
				load_gir();
				load_tests();
			} catch (RunError err) {
				throw err;
			}
		}
		
		public void load_module() throws RunError
			requires(this.path != null)
		{
			var modname = path; //.replace(".so","");
			module = Module.open (modname, ModuleFlags.BIND_LOCAL);
			if (module == null)
				throw new RunError.MODULE(Module.error());
			module.make_resident();
		}
		
		public void load_gir() throws RunError
			requires(this.path != null)
			requires(this.module != null)
		{
			var girpath = path.replace(".libs/lt-","") + ".gir";
			
			gir = Xml.Parser.parse_file (girpath);
			if (gir == null)
				throw new RunError.GIR("Gir for %s not found", path);
			
		}

		private void* load_method(string method_name) throws RunError {
			void* function;
			if(module.symbol (method_name, out function))
				if (function != null)
					return function;
			throw new RunError.METHOD(Module.error());
		}
		
		public void load_tests() throws RunError
			requires(this.module != null)
		{

			string ns = "'http://www.gtk.org/introspection/core/1.0'";
			string xpath = @"//*[local-name()='class' and namespace-uri()=$ns and @parent='Valadate.FrameworkTestCase']";
			xpath += @"/*[local-name()='constructor' and namespace-uri()=$ns]";
			Xml.XPath.Context cntx = new Xml.XPath.Context (gir);
			Xml.XPath.Object* res = cntx.eval_expression (xpath);

			if (res == null ||
				res->type != Xml.XPath.ObjectType.NODESET ||
				res->nodesetval == null ||
				res->nodesetval->length() <= 0 )
				throw new RunError.TESTS("No TestCases were found");

			for (int i = 0; i < res->nodesetval->length (); i++) {
				Xml.Node* node = res->nodesetval->item (i);
				var gtype = node->get_prop("identifier");
				if(gtype == null)
					throw new RunError.TESTS("No Constructor found!");
				unowned CreateTestObject create = (CreateTestObject)load_method(gtype);

				TestCase test = create() as TestCase;
				
				if (test == null)
					throw new RunError.TESTS("Error creating test");
				
				_tests += test;
				
				Xml.Node* func = node->parent->children;
				if (func == null)
					throw new RunError.TESTS("No Unit Tests were found");

				while(func != null) {
					if (func->name == "method") {
						if(func->children != null) {
							Xml.Node* meth = func->children;
							while (meth != null) {
								if(meth->get_prop("key") == "test.name") {
									try {
										unowned TestMethod method = (TestMethod)load_method(func->get_prop("identifier"));
										test.add_test(meth->get_prop("value"), ()=> {method(test); });
									} catch (RunError e) {
										throw e;
									}
								}
								/*
								if(meth->get_prop("key") == "async-test.name") {
									try {
										unowned TestMethod method = (TestMethod)load_method(func->get_prop("identifier"));
										test.add_test(meth->get_prop("value"), ()=> {method(test); });
									} catch (RunError e) {
										throw e;
									}
								}*/
								meth = meth->next;
							}
						}
					}
					func = func->next;
				}
			}
			delete res;
		}
	}

	public int main (string[] args) {

		TextRunner runner = new TextRunner(args[0]);

		GLib.Test.init (ref args);

		try {
			runner.load();
		} catch (RunError err) {
			debug(err.message);
			return -1;
		}

		foreach (Test test in runner.tests)
			GLib.TestSuite.get_root().add_suite(((TestCase)test).suite);

		GLib.Test.run ();
		return 0;
		
	}

}
