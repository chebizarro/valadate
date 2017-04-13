namespace Valadate.Tests {

	public static void new_gir_test_plan() {
		
		var oldenv = Environment.get_variable("G_TEST_SRCDIR");
		var builddir = Environment.get_variable("G_TEST_BUILDDIR");
		
		var newenv = File.new_for_path(Path.build_filename(
			oldenv, "..", "data"));
		
		var binary = File.new_for_path(Path.build_filename(
			builddir, "..", "data", ".libs", "testexe-0"));
		
		Environment.set_variable("G_TEST_SRCDIR", newenv.get_path(), true);
		
		var assembly = new TestAssembly({ binary.get_path() });
		
		var tplan = TestPlan.new(assembly); 
		
		assert(tplan is TestPlan);
		assert(tplan is GirTestPlan);
	}

	public static void gir_test_plan_no_of_testsuites() {
		
		var builddir = Environment.get_variable("G_TEST_BUILDDIR");
		
		var binary = File.new_for_path(Path.build_filename(
			builddir, "..", "data", ".libs", "testexe-0"));
		
		var assembly = new TestAssembly({ binary.get_path() });
		
		var tplan = TestPlan.new(assembly); 

		var conf = tplan.config;
		
		assert(tplan.root[0].size == 4);
	}

	public static void gir_test_plan_no_of_tests() {
		
		var builddir = Environment.get_variable("G_TEST_BUILDDIR");
		
		var binary = File.new_for_path(Path.build_filename(
			builddir, "..", "data", ".libs", "testexe-0"));
		
		var assembly = new TestAssembly({ binary.get_path() });
		
		var tplan = TestPlan.new(assembly); 

		var conf = tplan.config;
		
		assert(tplan.root[0][0].name == "TestsTestExe");
		//debug("%d", tplan.root[0][0].count);
		//assert(tplan.root[0][0].count == 6);
	}

	public static void gir_test_plan_tests_abstract() {
		
		var builddir = Environment.get_variable("G_TEST_BUILDDIR");
		
		var binary = File.new_for_path(Path.build_filename(
			builddir, "..", "data", ".libs", "testexe-0"));
		
		var assembly = new TestAssembly({ binary.get_path() });
		
		var tplan = TestPlan.new(assembly); 

		var conf = tplan.config;
		
		assert(tplan.root[0][3].name == "TestsTestExeAbstractImpl");
		assert(tplan.root[0][3].count == 4);
	}

	public static void gir_test_plan_no_of_inherited_tests() {
		
		var builddir = Environment.get_variable("G_TEST_BUILDDIR");
		
		var binary = File.new_for_path(Path.build_filename(
			builddir, "..", "data", ".libs", "testexe-0"));
		
		var assembly = new TestAssembly({ binary.get_path() });
		
		var tplan = TestPlan.new(assembly); 

		var conf = tplan.config;
		
		assert(tplan.root[0][1].name == "TestsTestExeSubClass");
		//assert(tplan.root[0][1].count == 6);
	}

	public static void gir_test_plan_tests_with_label() {
		
		var builddir = Environment.get_variable("G_TEST_BUILDDIR");
		
		var binary = File.new_for_path(Path.build_filename(
			builddir, "..", "data", ".libs", "testexe-0"));
		
		var assembly = new TestAssembly({ binary.get_path() });
		
		var tplan = TestPlan.new(assembly); 

		var conf = tplan.config;
		
		assert(tplan.root[0][2].name == "TestsTestExeTwo");
		//assert(tplan.root[0][2].count == 2);
		assert(tplan.root[0][2][0].label == "/Valadate/TestsTestExeTwo/Test One");
		assert(tplan.root[0][2][1].label == "/Valadate/TestsTestExeTwo/Test Two");
	}

	public static void gir_test_plan_run_single_test() {
		
		var builddir = Environment.get_variable("G_TEST_BUILDDIR");
		
		var binary = File.new_for_path(Path.build_filename(
			builddir, "..", "data", ".libs", "testexe-0"));
		
		var testpath = "/Valadate/TestsTestExe/test_simple";
		
		var assembly = new TestAssembly({ binary.get_path(), "-r", testpath });
		
		var tplan = TestPlan.new(assembly); 

		var conf = tplan.config;
		
		//assert(tplan.root[0][0].count == 1);
		//assert(tplan.root[0][1].count == 0);
	}

}
