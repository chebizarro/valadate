namespace Valadate.Tests {

	public static void new_gir_test_plan() {
		
		var assembly = new TestAssembly({ testbinary.get_path() });

		var plan_file = 
			File.new_for_path(Environment.get_variable("G_TEST_SRCDIR")).get_child("testexe-0.gir");

		var tplan = Object.new(typeof(GirTestPlan), "assembly", assembly, "plan", plan_file) as TestPlan;
		
		assert(tplan is TestPlan);
		assert(tplan is GirTestPlan);
	}

	public static void gir_test_plan_no_of_testsuites() {
		
		var assembly = new TestAssembly({ testbinary.get_path() });
		
		var plan_file = 
			File.new_for_path(Environment.get_variable("G_TEST_SRCDIR")).get_child("testexe-0.gir");

		var tplan = Object.new(typeof(GirTestPlan), "assembly", assembly, "plan", plan_file) as TestPlan;

		assert(tplan.root[0].size == 4);
	}

	public static void gir_test_plan_no_of_tests() {
		
		var assembly = new TestAssembly({ testbinary.get_path() });
		
		var plan_file = 
			File.new_for_path(Environment.get_variable("G_TEST_SRCDIR")).get_child("testexe-0.gir");

		var tplan = Object.new(typeof(GirTestPlan), "assembly", assembly, "plan", plan_file) as TestPlan;

		assert(tplan.root[0][0].name == "TestsTestExe");
		assert(tplan.root[0][0].count == 6);
	}

	public static void gir_test_plan_tests_abstract() {
		
		var assembly = new TestAssembly({ testbinary.get_path() });
		
		var plan_file = 
			File.new_for_path(Environment.get_variable("G_TEST_SRCDIR")).get_child("testexe-0.gir");

		var tplan = Object.new(typeof(GirTestPlan), "assembly", assembly, "plan", plan_file) as TestPlan;

		assert(tplan.root[0][3].name == "TestsTestExeAbstractImpl");
		assert(tplan.root[0][3].count == 4);
	}

	public static void gir_test_plan_no_of_inherited_tests() {
		
		var assembly = new TestAssembly({ testbinary.get_path() });
		
		var plan_file = 
			File.new_for_path(Environment.get_variable("G_TEST_SRCDIR")).get_child("testexe-0.gir");

		var tplan = Object.new(typeof(GirTestPlan), "assembly", assembly, "plan", plan_file) as TestPlan;

		assert(tplan.root[0][1].name == "TestsTestExeSubClass");
		assert(tplan.root[0][1].count == 7);
	}

	public static void gir_test_plan_tests_with_label() {

		var assembly = new TestAssembly({ testbinary.get_path() });
		
		var plan_file = 
			File.new_for_path(Environment.get_variable("G_TEST_SRCDIR")).get_child("testexe-0.gir");

		var tplan = Object.new(typeof(GirTestPlan), "assembly", assembly, "plan", plan_file) as TestPlan;

		assert(tplan.root[0][2].name == "TestsTestExeTwo");
		assert(tplan.root[0][2].size == 3);
		assert(tplan.root[0][2][0].label == "/Valadate/TestsTestExeTwo/Test One");
		assert(tplan.root[0][2][1].label == "/Valadate/TestsTestExeTwo/Test Two");
	}

	public static void gir_test_plan_run_single_test() {
		
		var testpath = "/Valadate/TestsTestExe/test_simple";
		
		var assembly = new TestAssembly({ testbinary.get_path(), "-r", testpath });
		
		var plan_file = 
			File.new_for_path(Environment.get_variable("G_TEST_SRCDIR")).get_child("testexe-0.gir");

		var tplan = Object.new(typeof(GirTestPlan), "assembly", assembly, "plan", plan_file) as TestPlan;

		assert(tplan.root.count == 1);
		assert(tplan.root[0][0].size == 1);
		//tplan.run();
	}


}
