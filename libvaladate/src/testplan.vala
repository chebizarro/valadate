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

	public interface TestPlan : Object {

		[CCode (has_target = false)]
		public delegate void TestMethod(TestCase self) throws Error;

		public delegate void AsyncTestMethod(TestCase self, AsyncReadyCallback cb);
		public delegate void AsyncTestMethodResult(TestCase self, AsyncResult res);


		private static HashTable<string, Type> plan_types;
		
		private static void initialise() {
			if(plan_types != null)
				return;

			plan_types = new HashTable<string, Type>(str_hash, str_equal);
			plan_types.insert("gir", typeof(GirTestPlan));
			//plan_types.insert("vapi", typeof(VapiTestPlan));

		}

		public static TestPlan @new(TestAssembly assembly) throws ConfigError {

			initialise();

			string plan_name = Path.get_basename(assembly.binary.get_path());
			if(plan_name.has_prefix("lt-"))
				plan_name = plan_name.substring(3);
				
				
			File plan_file = assembly.srcdir;

			foreach(var key in plan_types.get_keys()) {
				
				
				plan_file = assembly.srcdir.get_child(plan_name + "." + key);
	 			
	 			if(plan_file.query_exists()) {

					return Object.new(plan_types[key], "assembly", assembly, "plan", plan_file) as TestPlan;

				} else {

					plan_file = assembly.builddir.get_child(plan_name + "." + key);

					if(plan_file.query_exists()) {

						return Object.new(plan_types[key], "assembly", assembly, "plan", plan_file) as TestPlan;

					}
				}
			}
			
			throw new ConfigError.TESTPLAN("Test Plan %s Not Found in %s or %s", plan_name, assembly.srcdir.get_path(), assembly.builddir.get_path());
		}
		
		public abstract File plan {get;construct set;}

		public abstract TestAssembly assembly {get;construct set;}

		public abstract TestOptions options {get;set;}

		public abstract TestConfig config {get;set;}

		public abstract TestResult result {get;set;}
		
		public abstract TestRunner runner {get;set;}

		public abstract TestSuite root {get;protected set;}

		public abstract int run() throws Error;
		
	}

}
