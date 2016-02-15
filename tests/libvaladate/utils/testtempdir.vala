/*
 * Valadate - Unit testing library for GObject-based libraries.
 * Copyright (C) 2016  Chris Daley <chebizarro@gmail.com>
 * Copyright (C) 2009  Jan Hudec <bulb@ucw.cz>
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

namespace Valadate.Tests {
	
	using Valadate;
	using Valadate.Utils;
	
    public class TempDirTest : TestCase {

		public TempDirTest() {
			add_test("store", test_store);
			add_test("copy", test_copy_file);
			add_test("shell", test_shell);
			add_test("copy_dir", test_copy_dir);
		}


        TempDir tmp = new TempDir();

        public void test_store() {
            tmp.store("foo", "This is file foo!\n");
            assert(tmp.contents("foo") == "This is file foo!\n");
        }

        public void test_copy_file() {
            tmp.copy("readme", Config.VALADATE_TESTS_DIR + "/../README.md");
            var readme = tmp.contents("readme");
            assert(readme.has_prefix("Valadate"));
        }

        public void test_shell() {
            tmp.shell("foo1", "echo foobar > bar");
            assert(tmp.contents("foo1/bar") == "foobar\n");
        }

        public void test_copy_dir() {
            tmp.shell("foo2", "echo qyzzy > qyzzy; mkdir 42; echo 42/baz > 42/baz\n");
            tmp.copy("bar", tmp.dir.resolve_relative_path("foo2").get_path());
            assert(tmp.contents("bar/qyzzy") == "qyzzy\n");
            assert(tmp.contents("bar/42/baz") == "42/baz\n");
        }
    }
}
