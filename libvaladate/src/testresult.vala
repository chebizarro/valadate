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

namespace Valadate { 

	public interface TestResult : Object {

		public abstract TestConfig config {get;construct set;}

		public abstract int testcount {get;internal set;default=0;}

		public abstract void start(Test test);

		public abstract bool report();
		
		public abstract void add_error(Test test, string error);

		public abstract void add_failure(Test test, string failure);

		public abstract void add_success(Test test, string message);
		
		public abstract void add_skip(Test test, string reason, string message);
		
		public abstract void add_test(Test test);

		public abstract void add_test_start(Test test);
		
		public abstract void add_test_end(Test test);

	}
}
