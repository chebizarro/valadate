/*
 * Valadate - Unit testing library for GObject-based libraries.
 * Copyright (C) 2016  Chris Daley <chebizarro@gmail.com>
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


namespace Valadate.Introspection.Tests {
	
	using Valadate;
	using Valadate.Introspection;

	private const string LIBPATH = Config.VALADATE_TESTS_DIR +"/libvaladate/data/.libs/lt-testexe-0";
	private const string GIRPATH = Config.VALADATE_TESTS_DIR +"/libvaladate/data/testexe-0.gir";

    public class ModuleTest : Framework.TestCase {

		public ModuleTest() {
			add_test("new", test_new);
			add_test("load_module", test_load_module);
		}

        public void test_new() {
			Module module = new Module(LIBPATH);

			assert(module is Module);
        }

        public void test_load_module() {
			Module module = new Module(LIBPATH);

			module.load_module();

			assert(module != null);
        }
    }

	public class IntrospectionTest : Framework.TestCase {
		
		public IntrospectionTest() {
			add_test("get_class_by_type", test_get_class_by_type);
			add_test("get_class_by_name", test_get_class_by_name);
			add_test("get_class_instance", test_get_class_instance);
			add_test("get_methods", test_get_methods);
			add_test("get_method", test_get_method);
			add_test("call_method_one", test_call_method_one);
			//add_test("call_method_one_with_param", test_call_method_one_with_param);
			add_test("call_method_two", test_call_method_two);
		}
		
		public override void set_up() {
			Repository.add_package(LIBPATH, GIRPATH);
		}

		public void test_get_class_by_type() {
			Class[] class = Repository.get_class_by_type(typeof(Framework.Test));
			
			assert(class.length == 3);
			assert(class[0].class_type.is_a(typeof(Framework.TestCase)));
		}

		public void test_get_class_by_name() {
			Class class = Repository.get_class_by_name("FrameworkTestsTestExeTwo");
			
			assert(class.class_type.is_a(typeof(Framework.TestCase)));
		}

		public void test_get_methods() {
			Class class = Repository.get_class_by_name("FrameworkTestsTestExe");

			var methods = class.get_methods();

			assert(methods.length == 6);
		}

		public void test_get_method() {
			Class class = Repository.get_class_by_name("FrameworkTestsTestExe");

			void* method = class.get_method("valadate_framework_tests_test_exe_test_one");
			
			assert(method != null);
		}

		public void test_get_class_instance() {
			Class class = Repository.get_class_by_name("FrameworkTestsTestExe");

			var instance = class.get_instance() as Framework.TestCase;
			
			assert(instance is Framework.TestCase);
		}
		
		
		public void test_call_method_one () {
			Class cls = Repository.get_class_by_name("FrameworkTestsTestExe");
			var instance = cls.get_instance() as Framework.TestCase;
			var methods = cls.get_methods();

			methods[0].call(instance);
			
		}

		public void test_call_method_one_with_param () {
			Class cls = Repository.get_class_by_name("FrameworkTestsTestExeSubClass");
			var instance = cls.get_instance() as Framework.TestCase;
			var methods = cls.get_methods();
			
			void* i = methods[0].call(instance, 10);
			
			message(((int)i).to_string());
			
			assert((int)i == 10);
			
		}

		internal delegate void TestMethod(Framework.TestCase self);

		public void test_call_method_two () {
			Class cls = Repository.get_class_by_name("FrameworkTestsTestExe");
			var instance = cls.get_instance() as Framework.TestCase;
			unowned TestMethod testmethod = (TestMethod)cls.get_method("valadate_framework_tests_test_exe_test_one");
			
			testmethod(instance);
		}
		
	}


}
