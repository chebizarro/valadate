namespace Valadate.Tests {

	public static void new_vapi_test_plan() {
		
		var assembly = new TestAssembly({ testbinary.get_path() });
		var plan_file = 
			File.new_for_path(Environment.get_variable("G_TEST_SRCDIR")).get_child("testexe-0.vapi");
		
		var tplan = Object.new(typeof(VapiTestPlan), "assembly", assembly, "plan", plan_file) as TestPlan;
		
		assert(tplan is TestPlan);
		assert(tplan is VapiTestPlan);
	}

	public static void vapi_test_plan_no_of_testsuites() {
		
		var assembly = new TestAssembly({ testbinary.get_path() });
		var plan_file = 
			File.new_for_path(Environment.get_variable("G_TEST_SRCDIR")).get_child("testexe-0.vapi");
		
		var tplan = Object.new(typeof(VapiTestPlan), "assembly", assembly, "plan", plan_file) as TestPlan;

		assert(tplan.root is TestSuite);
		assert(tplan.root[0][0].size == 4);
	}

	public static void vapi_test_plan_no_of_tests() {
		
		var assembly = new TestAssembly({ testbinary.get_path() });
		var plan_file = 
			File.new_for_path(Environment.get_variable("G_TEST_SRCDIR")).get_child("testexe-0.vapi");
		
		var tplan = Object.new(typeof(VapiTestPlan), "assembly", assembly, "plan", plan_file) as TestPlan;
		
		assert(tplan.root[0][0][0].name == "TestExe");
		assert(tplan.root[0][0][0].count == 6);
	}

	public static void vapi_test_plan_tests_abstract() {
		
		var assembly = new TestAssembly({ testbinary.get_path() });
		var plan_file = 
			File.new_for_path(Environment.get_variable("G_TEST_SRCDIR")).get_child("testexe-0.vapi");

		var tplan = Object.new(typeof(VapiTestPlan), "assembly", assembly, "plan", plan_file) as TestPlan;
		
		assert(tplan.root[0][0][1].name == "TestExeAbstractImpl");
		assert(tplan.root[0][0][1].count == 4);
	}

	public static void vapi_test_plan_no_of_inherited_tests() {
		
		var assembly = new TestAssembly({ testbinary.get_path() });
		var plan_file = 
			File.new_for_path(Environment.get_variable("G_TEST_SRCDIR")).get_child("testexe-0.vapi");

		var tplan = Object.new(typeof(VapiTestPlan), "assembly", assembly, "plan", plan_file) as TestPlan;

		assert(tplan.root[0][0][2].name == "TestExeSubClass");
		assert(tplan.root[0][0][2].count == 7);
	}

	public static void vapi_test_plan_tests_with_label() {

		var assembly = new TestAssembly({ testbinary.get_path() });
		var plan_file = 
			File.new_for_path(Environment.get_variable("G_TEST_SRCDIR")).get_child("testexe-0.vapi");
		
		var tplan = Object.new(typeof(VapiTestPlan), "assembly", assembly, "plan", plan_file) as TestPlan;

		assert(tplan.root[0][0][3].name == "TestExeTwo");
		assert(tplan.root[0][0][3].count == 3);
		assert(tplan.root[0][0][3][1].label == "/Valadate/Tests/TestExeTwo/Test One");
		assert(tplan.root[0][0][3][2].label == "/Valadate/Tests/TestExeTwo/Test Two");
	}

	public static void vapi_test_plan_run_single_test() {
		
		var testpath = "/Valadate/Tests/TestExe/test_simple";
		var assembly = new TestAssembly({ testbinary.get_path(), "-r", testpath });
		var plan_file = 
			File.new_for_path(Environment.get_variable("G_TEST_SRCDIR")).get_child("testexe-0.vapi");

		var tplan = Object.new(typeof(VapiTestPlan), "assembly", assembly, "plan", plan_file) as TestPlan;

		assert(tplan.root.count == 1);
		
		//tplan.run();
	}
}
