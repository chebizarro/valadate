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

	using Valadate.Introspection;


	public errordomain RunError {
		MODULE,
		GIR,
		TESTS,
		METHOD
	}

	public class TextRunner : Object, TestRunner {
		
		public delegate Object CreateTestObject();
		public delegate void TestMethod(TestCase self);
		
		private string path;
		private Test[] _tests;
		
		public Test[] tests {
			get {
				return _tests;
			}
		}
		
		public TextRunner(string path) {
			this.path = path;
		}
		
		
		public void load() throws RunError {
			try {
				Repository.add_package(path, path.replace(".libs/lt-","") + ".gir");
				load_tests();
			} catch (Valadate.Introspection.Error e) {
				throw new RunError.MODULE(e.message);
			}
		}
		
		public void load_tests() throws RunError {
			Class[] tests = Repository.get_class_by_type(typeof(Framework.Test));

			foreach (Class testcls in tests) {
				if (testcls.abstract)
					continue;

				TestCase test = testcls.get_instance() as Framework.TestCase; 

				_tests += test;

				foreach (Method method in testcls.get_methods()) {
					foreach (Annotation ano in method.annotations)
						if (ano.key.has_prefix("test.")) {
							unowned TestMethod testmethod = 
								(TestMethod)testcls.get_method(method.identifier);
							test.add_test(method.name, ()=> {testmethod(test); });
						}
				}
			}

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
