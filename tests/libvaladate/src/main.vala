namespace Valadate.Tests {

	static void main (string[] args) {

		GLib.Test.init (ref args);

		GLib.Test.add_func ("/testplan/new", new_test_plan);
		GLib.Test.add_func ("/testplan/number of testsuites", test_plan_no_of_testsuites);
		GLib.Test.add_func ("/testplan/number of tests", test_plan_no_of_tests);
		GLib.Test.add_func ("/testplan/number of abstract tests", test_plan_tests_abstract);
		GLib.Test.add_func ("/testplan/number of inherited tests", test_plan_no_of_inherited_tests);
		GLib.Test.add_func ("/testplan/tests with labels", test_plan_tests_with_label);
		GLib.Test.add_func ("/testplan/run single test", test_plan_run_single_test);

		GLib.Test.run ();

	}
}
