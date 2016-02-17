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
	private const string XSLPATH = Config.VALADATE_TESTS_DIR +"/libvaladate/data/gir.xsl";
	private const string JSONPATH = GIRPATH + ".json";
	
	public class IntrospectionTest : TestCase {
		
		public IntrospectionTest() {
			add_test("add_repository", test_add_repository);
			add_test("get_class", test_get_class);
		}
		
		public void test_add_repository() {
			add_repository(LIBPATH, GIRPATH);
			assert(get_modules() != null);
		}

		public void test_get_class() {
			add_repository(LIBPATH, GIRPATH);
			Class class = get_class_info(typeof(TestCase));
			//assert(class != null);
			//assert(class is Class);
		}
		
	}
	
    public class RepositoryTest : TestCase {

		public RepositoryTest() {
			add_test("new", test_new);
			add_test("load_xml", test_load_xml);
		}

        public void test_new() {
			Repository repo = new Repository();
			assert(repo != null);
			assert(repo is Repository);
        }
        
        public void test_load_xml() {
			var document = Xml.Parser.parse_file (GIRPATH);
			var stylesheet = Xslt.parse_stylesheet_file(XSLPATH);
			var result = stylesheet->apply(document, {});
			assert(result != null);
			//result->save_file(GIRPATH + ".json");

			string output;
			int length;
			int res = stylesheet->save_result_to_string(out output, out length, result);

			var repo = Json.gobject_from_data(typeof(Repository), output) as Repository;

			assert (repo is Repository);
			assert (repo.package.name == "testexe");
			assert (repo.includes[0].name == "Valadate");
			assert (repo.includes != null);
			
			/*
			Json.Parser parser = new Json.Parser ();
			parser.load_from_data (output);

			Json.Generator generator = new Json.Generator ();
			generator.pretty = true;
			Json.Node root = parser.get_root ();
			generator.set_root (root);
			generator.to_file(JSONPATH);
			*/
			
			delete document;
			delete stylesheet;
			delete result;
		}
    }

    public class ModuleTest : TestCase {

		public ModuleTest() {
			add_test("new", test_new);
			add_test("load_module", test_load_module);
		}

        public void test_new() {
			Module module = new Module(LIBPATH, GIRPATH);
			assert(module != null);
			assert(module is Module);
        }

        public void test_load_module() {
			Module module = new Module(LIBPATH, GIRPATH);
			module.load_module();
			assert(module != null);
        }
    }
}
