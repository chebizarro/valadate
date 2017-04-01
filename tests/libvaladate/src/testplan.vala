namespace Valadate.Tests {

	public static void new_test_plan() {
		
		var oldenv = Environment.get_variable("G_TEST_SRCDIR");
		var builddir = Environment.get_variable("G_TEST_BUILDDIR");
		
		var newenv = File.new_for_path(Path.build_filename(
			oldenv, "..", "data"));
		
		var binary = File.new_for_path(Path.build_filename(
			builddir, "..", "data", ".libs", "testexe-0"));
		
		Environment.set_variable("G_TEST_SRCDIR", newenv.get_path(), true);
		
		var options = new TestOptions({ binary.get_path() });
		
		var tplan = TestPlan.new(options); 
		
		assert(tplan is TestPlan);
		assert(tplan is GirTestPlan);
	}

	public static void test_plan_no_of_testsuites() {
		
		var builddir = Environment.get_variable("G_TEST_BUILDDIR");
		
		var binary = File.new_for_path(Path.build_filename(
			builddir, "..", "data", ".libs", "testexe-0"));
		
		var options = new TestOptions({ binary.get_path() });
		
		var tplan = TestPlan.new(options); 

		var conf = tplan.config;
		
		assert(conf.root[0].count == 4);
	}

	public static void test_plan_no_of_tests() {
		
		var builddir = Environment.get_variable("G_TEST_BUILDDIR");
		
		var binary = File.new_for_path(Path.build_filename(
			builddir, "..", "data", ".libs", "testexe-0"));
		
		var options = new TestOptions({ binary.get_path() });
		
		var tplan = TestPlan.new(options); 

		var conf = tplan.config;
		
		assert(conf.root[0][0].name == "TestsTestExe");
		assert(conf.root[0][0].count == 5);
	}

	public static void test_plan_tests_abstract() {
		
		var builddir = Environment.get_variable("G_TEST_BUILDDIR");
		
		var binary = File.new_for_path(Path.build_filename(
			builddir, "..", "data", ".libs", "testexe-0"));
		
		var options = new TestOptions({ binary.get_path() });
		
		var tplan = TestPlan.new(options); 

		var conf = tplan.config;
		
		assert(conf.root[0][3].name == "TestsTestExeAbstractImpl");
		assert(conf.root[0][3].count == 4);
	}

	public static void test_plan_no_of_inherited_tests() {
		
		var builddir = Environment.get_variable("G_TEST_BUILDDIR");
		
		var binary = File.new_for_path(Path.build_filename(
			builddir, "..", "data", ".libs", "testexe-0"));
		
		var options = new TestOptions({ binary.get_path() });
		
		var tplan = TestPlan.new(options); 

		var conf = tplan.config;
		
		assert(conf.root[0][1].name == "TestsTestExeSubClass");
		assert(conf.root[0][1].count == 6);
	}

	public static void test_plan_tests_with_label() {
		
		var builddir = Environment.get_variable("G_TEST_BUILDDIR");
		
		var binary = File.new_for_path(Path.build_filename(
			builddir, "..", "data", ".libs", "testexe-0"));
		
		var options = new TestOptions({ binary.get_path() });
		
		var tplan = TestPlan.new(options); 

		var conf = tplan.config;
		
		assert(conf.root[0][2].name == "TestsTestExeTwo");
		assert(conf.root[0][2].count == 2);
		assert(conf.root[0][2][0].label == "Test One");
		assert(conf.root[0][2][1].label == "Test Two");
	}

	public static void test_plan_run_single_test() {
		
		var builddir = Environment.get_variable("G_TEST_BUILDDIR");
		
		var binary = File.new_for_path(Path.build_filename(
			builddir, "..", "data", ".libs", "testexe-0"));
		
		var testpath = "/testexe/TestsTestExe/test_simple";
		
		var options = new TestOptions({ binary.get_path(), "-r", testpath });
		
		var tplan = TestPlan.new(options); 

		var conf = tplan.config;
		
		assert(conf.root[0][0].count == 1);
		assert(conf.root[0][1].count == 0);
	}

}
