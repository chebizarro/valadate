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

	public class SerialTestRunner : Object, TestRunner {

		public void run_all(TestPlan plan) {
			Environment.set_variable("G_MESSAGES_DEBUG", "all", true);

			if(!plan.config.keep_going) {
				Environment.set_variable("G_DEBUG","fatal-criticals fatal-warnings gc-friendly", true);
				Environment.set_variable("G_SLICE","always-malloc debug-blocks", true);
			}

			plan.root.run(plan.result);
			plan.result.report();
		}

		public void run(Test test, TestResult result) {
			test.run(result);
			result.report();
		}

	}
}
