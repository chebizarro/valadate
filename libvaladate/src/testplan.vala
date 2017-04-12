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

			string currdir = Environment.get_current_dir();
			string plan_name = Path.get_basename(assembly.binary.get_path());
			string builddir = Path.get_dirname(assembly.binary.get_path());
			string srcdir = Environment.get_variable("G_TEST_SRCDIR") ??
				Environment.get_variable("srcdir") ??
				currdir;
			
			if(plan_name.has_prefix("lt-"))
				plan_name = plan_name.substring(3);

			if(Path.get_basename(builddir) == ".libs")
				builddir = builddir[0 : builddir.length-6];

			if(!Path.is_absolute(builddir))
				builddir = currdir + builddir;

			if(!Path.is_absolute(srcdir))
				srcdir = currdir + srcdir;

			foreach(var key in plan_types.get_keys()) {
				var plan_file = File.new_for_path(Path.build_filename(srcdir, plan_name + "." + key));
	 			if(plan_file.query_exists()) {
					return Object.new(plan_types[key], "assembly", assembly, "plan", plan_file) as TestPlan;
				} else {
					plan_file = File.new_for_path(Path.build_filename(builddir, plan_name + "." + key));
					if(plan_file.query_exists()) {
						return Object.new(plan_types[key], "assembly", assembly, "plan", plan_file) as TestPlan;
					}
				}
			}
			throw new ConfigError.TESTPLAN("Test Plan %s Not Found!", plan_name);
		}
		
		public abstract File plan {get;construct set;}

		public abstract TestAssembly assembly {get;construct set;}

		public abstract TestOptions options {get;set;}

		public abstract TestConfig config {get;set;}

		public abstract TestResult result {get;set;}
		
		public abstract TestRunner runner {get;set;}

		public abstract TestSuite root {get;protected set;}

		public abstract void run();
		
	}

}
