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

	public interface TestRunner : Object {

		private static Type default_type;

		public static void register_default(Type type)
			requires(type.is_a(typeof(TestRunner)))
		{
			default_type = type;
		}

		public static TestRunner @new(TestConfig config) {
			Type runner_type;
			
			if(default_type != Type.INVALID)
				runner_type = default_type;
			else if(config.run_async)
				runner_type = typeof(AsyncTestRunner);
			else
				runner_type = typeof(SerialTestRunner);

			return Object.new(runner_type) as TestRunner;
		}

		public abstract void run_all(TestPlan plan);

		public abstract void run(Test test, TestResult result);

	}
}
