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
	
	public class IntrospectionTest : Framework.TestCase {
		
		public IntrospectionTest() {
			add_test("add_package", test_add_package);
			add_test("get_class_by_type", test_get_class_by_type);
			add_test("get_class_by_name", test_get_class_by_name);
		}
		
		public void test_add_package() {
			Repository.add_package(LIBPATH, GIRPATH);
		}

		public void test_get_class_by_type() {
			Repository.add_package(LIBPATH, GIRPATH);
			Class[] class = Repository.get_class_by_type(typeof(Framework.Test));
			message(class.length.to_string());
			assert(class.length == 3);
			assert(class[0].class_type.is_a(typeof(Framework.TestCase)));
		}

		public void test_get_class_by_name() {
			Repository.add_package(LIBPATH, GIRPATH);
			Class class = Repository.get_class_by_name("FrameworkTestsTestExeTwo");
			assert(class.class_type.is_a(typeof(Framework.TestCase)));
		}
		
	}


    public class ModuleTest : Framework.TestCase {

		public ModuleTest() {
			add_test("new", test_new);
			add_test("load_module", test_load_module);
		}

        public void test_new() {
			Module module = new Module(LIBPATH);
			assert(module != null);
			assert(module is Module);
        }

        public void test_load_module() {
			Module module = new Module(LIBPATH);
			module.load_module();
			assert(module != null);
        }
    }
}
