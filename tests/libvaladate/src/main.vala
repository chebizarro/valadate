namespace Valadate.Tests {

	public static File testbinary;

	static void main (string[] args) {

		GLib.Test.init (ref args);

		var builddir = Environment.get_variable("G_TEST_BUILDDIR");
		testbinary = File.new_for_path(Path.build_filename(
			builddir, "..", "data", ".libs", "testexe-0"));

		var newenv = File.new_for_path(Path.build_filename(
			Environment.get_variable("G_TEST_SRCDIR"), "..", "data"));
		Environment.set_variable("G_TEST_SRCDIR", newenv.get_path(), true);

		GLib.Test.add_func ("/assembly/new", new_assembly);
		GLib.Test.add_func ("/assembly/newfail", new_assembly_fail);
		GLib.Test.add_func ("/assembly/newfail/subprocess", new_assembly_fail_subprocess);
		GLib.Test.add_func ("/assembly/run", run_assembly);
		GLib.Test.add_func ("/assembly/runfail", run_fail);
		GLib.Test.add_func ("/assembly/runfail/subprocess", run_fail_subprocess);
		
		GLib.Test.add_func ("/testassembly/new", new_test_assembly);
		GLib.Test.add_func ("/testassembly/srcdir", test_assembly_srcdir);
		GLib.Test.add_func ("/testassembly/builddir", test_assembly_builddir);
		GLib.Test.add_func ("/testassembly/getmethod", test_assembly_get_method);
		GLib.Test.add_func ("/testassembly/fuzzmethod", test_assembly_fuzz_fail);
		GLib.Test.add_func ("/testassembly/fuzzmethod/subprocess", test_assembly_fuzz_method);

		GLib.Test.add_func ("/testplan/new", new_test_plan);
		
		GLib.Test.add_func ("/girtestplan/new", new_gir_test_plan);
		GLib.Test.add_func ("/girtestplan/number of testsuites", gir_test_plan_no_of_testsuites);
		GLib.Test.add_func ("/girtestplan/number of tests", gir_test_plan_no_of_tests);
		GLib.Test.add_func ("/girtestplan/number of abstract tests", gir_test_plan_tests_abstract);
		GLib.Test.add_func ("/girtestplan/number of inherited tests", gir_test_plan_no_of_inherited_tests);
		GLib.Test.add_func ("/girtestplan/tests with labels", gir_test_plan_tests_with_label);
		GLib.Test.add_func ("/girtestplan/run single test", gir_test_plan_run_single_test);
		
		/*
		GLib.Test.add_func ("/vapitestplan/new", new_vapi_test_plan);
		GLib.Test.add_func ("/vapitestplan/number of testsuites", vapi_test_plan_no_of_testsuites);
		GLib.Test.add_func ("/vapitestplan/number of tests", vapi_test_plan_no_of_tests);
		GLib.Test.add_func ("/vapitestplan/number of abstract tests", vapi_test_plan_tests_abstract);
		GLib.Test.add_func ("/vapitestplan/number of inherited tests", vapi_test_plan_no_of_inherited_tests);
		GLib.Test.add_func ("/vapitestplan/tests with labels", vapi_test_plan_tests_with_label);
		GLib.Test.add_func ("/vapitestplan/run single test", vapi_test_plan_run_single_test);
		*/

		// TestSuite
		// TestCase
		// TestAdapter

		// TestConfig

		// TestResult
		GLib.Test.add_func ("/testresult/new", new_test_result);
		GLib.Test.add_func ("/testresult/addtest", test_result_add_test);
		GLib.Test.add_func ("/testresult/processbuffer", test_result_process_buffers);

		// TestRunner
		GLib.Test.add_func ("/asynctestrunner/new", new_async_test_runner);

		// TestReport
		GLib.Test.add_func ("/testreport/new", test_report_new);
		GLib.Test.add_func ("/testreport/newistestcase", test_report_new_is_testcase);
		GLib.Test.add_func ("/testreport/addtext", test_report_add_text);

		// TestPrinter

		GLib.Test.run ();

	}
}
