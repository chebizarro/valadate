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
		public delegate void TestMethod(Framework.TestCase self);
		public delegate void AsyncTestMethod(Framework.TestCase self, AsyncReadyCallback cb);
		public delegate void AsyncTestMethodResult(Framework.TestCase self, AsyncResult res);
		
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
			string girdir = Path.get_dirname(path).replace(".libs", "");
			string girfile = girdir + GLib.Path.DIR_SEPARATOR_S + 
				Path.get_basename(path).replace("lt-","") + ".gir";
			
			try {
				Repository.add_package(path, girfile);
				load_tests();
			} catch (Valadate.Introspection.Error e) {
				throw new RunError.MODULE(e.message);
			}
		}
		
		
		internal class AsyncMethod {
			public Method begin;
			public Method end;
		}
		
		public void load_tests() throws RunError {
			Class[] testclasses = Repository.get_class_by_type(typeof(Framework.Test));

			foreach (Class testcls in testclasses) {
				if (testcls.abstract)
					continue;

				var test = testcls.get_instance() as Framework.TestCase; 

				_tests += test;

				HashTable<string,AsyncMethod> async_tests = 
					new HashTable<string,AsyncMethod>(str_hash, str_equal);

				foreach (Method method in testcls.get_methods()) {
					int timeout = 200;
					foreach (Annotation ano in method.annotations) {
						if (ano.key.has_prefix("test.name")) {
							unowned TestMethod testmethod = 
								(TestMethod)testcls.get_method(method.identifier);
							test.add_test(method.name, ()=> {testmethod(test); });
							continue;
						} else if (ano.key.has_prefix("async-test.timeout")) {
							timeout = int.parse(ano.value);
						} else if (ano.key.has_prefix("async-test.name")) {
							if(!async_tests.contains(ano.value))
								async_tests.set(ano.value, new AsyncMethod());
							
							AsyncMethod methods = async_tests.get(ano.value);
							
							if(method.parameters[0].name == "_res_") {
								methods.end = method;
							} else {
								methods.begin = method;
							}
							
							if (methods.begin != null && methods.end != null) {
								
								unowned AsyncTestMethod testmethod = 
									(AsyncTestMethod)testcls.get_method(methods.begin.identifier);

								unowned AsyncTestMethodResult testmethodresult = 
									(AsyncTestMethodResult)testcls.get_method(methods.end.identifier);
								
								test.add_async_test(
									ano.value,
									(cb) => {
										testmethod(test, cb);
									},
									(res) => {
										testmethodresult(test, res);
									},
									timeout
								);
							}
						}
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
