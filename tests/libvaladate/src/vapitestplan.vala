namespace Valadate.Tests {

	public static void new_vapi_test_plan() {
		
		var assembly = new TestAssembly({ testbinary.get_path() });
		
		var tplan = TestPlan.new(assembly); 
		
		assert(tplan is TestPlan);
		assert(tplan is VapiTestPlan);
	}

	public static void vapi_test_plan_no_of_testsuites() {
		
		var assembly = new TestAssembly({ testbinary.get_path() });
		
		var tplan = TestPlan.new(assembly); 

		var conf = tplan.config;
		
		assert(tplan.root[0].size == 4);
	}

	public static void vapi_test_plan_no_of_tests() {
		
		var assembly = new TestAssembly({ testbinary.get_path() });
		
		var tplan = TestPlan.new(assembly); 

		var conf = tplan.config;
		
		assert(tplan.root[0][0].name == "TestsTestExe");
		//debug("%d", tplan.root[0][0].count);
		//assert(tplan.root[0][0].count == 6);
	}

	public static void vapi_test_plan_tests_abstract() {
		
		var assembly = new TestAssembly({ testbinary.get_path() });
		
		var tplan = TestPlan.new(assembly); 

		var conf = tplan.config;
		
		assert(tplan.root[0][3].name == "TestsTestExeAbstractImpl");
		assert(tplan.root[0][3].count == 4);
	}

	public static void vapi_test_plan_no_of_inherited_tests() {
		
		var assembly = new TestAssembly({ testbinary.get_path() });
		
		var tplan = TestPlan.new(assembly); 

		var conf = tplan.config;
		
		assert(tplan.root[0][1].name == "TestsTestExeSubClass");
		//assert(tplan.root[0][1].count == 6);
	}

	public static void vapi_test_plan_tests_with_label() {

		var assembly = new TestAssembly({ testbinary.get_path() });
		
		var tplan = TestPlan.new(assembly); 

		var conf = tplan.config;
		
		assert(tplan.root[0][2].name == "TestsTestExeTwo");
		//assert(tplan.root[0][2].count == 2);
		assert(tplan.root[0][2][0].label == "/Valadate/TestsTestExeTwo/Test One");
		assert(tplan.root[0][2][1].label == "/Valadate/TestsTestExeTwo/Test Two");
	}

	public static void vapi_test_plan_run_single_test() {
		
		var testpath = "/Valadate/TestsTestExe/test_simple";
		
		var assembly = new TestAssembly({ testbinary.get_path(), "-r", testpath });
		
		var tplan = TestPlan.new(assembly); 

		var conf = tplan.config;
		
		//assert(tplan.root[0][0].count == 1);
		//assert(tplan.root[0][1].count == 0);
	}
}
