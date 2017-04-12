namespace Valadate.Tests {

	static void main (string[] args) {

		GLib.Test.init (ref args);

		GLib.Test.add_func ("/assembly/new", new_assembly);
		GLib.Test.add_func ("/assembly/newfail", new_assembly_fail);
		GLib.Test.add_func ("/assembly/newfail/subprocess", new_assembly_fail_subprocess);
		GLib.Test.add_func ("/assembly/run", run_assembly);
		GLib.Test.add_func ("/assembly/runfail", run_fail);
		GLib.Test.add_func ("/assembly/runfail/subprocess", run_fail_subprocess);
		GLib.Test.add_func ("/asynctestrunner/new", new_async_test_runner);
		GLib.Test.add_func ("/testplan/new", new_gir_test_plan);
		GLib.Test.add_func ("/testplan/number of testsuites", gir_test_plan_no_of_testsuites);
		GLib.Test.add_func ("/testplan/number of tests", gir_test_plan_no_of_tests);
		GLib.Test.add_func ("/testplan/number of abstract tests", gir_test_plan_tests_abstract);
		GLib.Test.add_func ("/testplan/number of inherited tests", gir_test_plan_no_of_inherited_tests);
		GLib.Test.add_func ("/testplan/tests with labels", gir_test_plan_tests_with_label);
		GLib.Test.add_func ("/testplan/run single test", gir_test_plan_run_single_test);
		GLib.Test.add_func ("/testresult/new", new_test_result);
		GLib.Test.add_func ("/testresult/addtest", test_result_add_test);
		GLib.Test.add_func ("/testresult/processbuffer", test_result_process_buffer);

		GLib.Test.run ();

	}
}
