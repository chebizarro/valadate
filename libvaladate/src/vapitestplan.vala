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

	public class VapiTestPlan : Object, TestPlan {

		public Assembly assembly {get;construct set;}
		public TestOptions options {get;protected set;}
		public TestConfig config {get;protected set;}
		public TestResult result {get;protected set;}
		public TestRunner runner {get;protected set;}
		public TestSuite root {get;protected set;}
		public File plan {get;construct set;}

		private TestSuite testsuite;
		private TestCase testcase;
		private string currpath;
		
		private VapiDriver driver; 

		construct {
			try {
				options = ((TestAssembly)assembly).options;
				testsuite = root = new TestSuite("/");
				load();
			} catch (Error e) {
				error(e.message);
			}
		}

		private void load() throws ConfigError {
			var version = get_version();
			driver = VapiDriver.new(version);
			driver.load_test_plan(plan, this);
		}

		private string get_version() {
			var dis = new DataInputStream(plan.read());
			var line = dis.read_line().split(" ");
			if(line[4] == "valac") {
				var vers = line[5].split(".");
				return string.joinv(".",vers[0:2]);
			} else if (line[4].has_prefix("vapigen-")) {
				return line[4].split("-")[1];
			}
			return "";
		}

		public void run() {
			runner.run_all(this);
		}
		
	}

}
