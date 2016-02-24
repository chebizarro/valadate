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
	
	public class TestExe : TestCase {
		
		[Test (name="test_one")]
		public void test_one () {
			Assert.is_true(true);
		}

		[Test (name="test_two")]
		public void test_two () {
			assert_true(true);
		}

		[AsyncTest (name="test_async", timeout=100000)]
		public async void test_async () throws ThreadError {
			debug("Async Test called");
			assert_true(true);
			//throw new ThreadError.AGAIN("Test error");
		}

		[AsyncTest (name="test_async_two")]
		public async void test_async_finish () throws ThreadError {
			debug("Async Test called");
			assert_true(true);
		}
		
	}

	public class TestExeSubClass : TestExe {

		public void test_method() {
			assert_true(true);
		}

	}
	
}
