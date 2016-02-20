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
 
namespace Valadate.Framework.Tests {
	

	public class TestExeTwo : TestCase {
		
		[Test (name="test_one")]
		public void test_one () {
			assert_true(true);
		}

		[Test (name="test_two")]
		public void test_two () {
			assert_true(true);
		}

		[AsyncTest (name="test_async_with_timeout", timeout="20000")]
		public async void test_async_with_timeout()
			throws GLib.Error, AssertError {
			var dir = File.new_for_path (GLib.Environment.get_current_dir());
			var e = yield dir.enumerate_children_async(
				FileAttribute.STANDARD_NAME, 0, Priority.DEFAULT, null);
			bool found = false; 
			while (true) {
				var files = yield e.next_files_async(10, Priority.DEFAULT, null);
				if (files == null)
					break;
				foreach (var info in files)
					if (info.get_name() == "testexetwo.vala")
						found = true;
			}
			assert(found);
		}

		
	}
	
}
