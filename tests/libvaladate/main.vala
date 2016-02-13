namespace Valadate.Tests {

	public class TestTestCase : TestCase {
		
		
	}

	static void main (string[] args) {

		GLib.Test.init (ref args);

		GLib.Test.add_func ("/testcase/new", () => {
			TestCase test = new TestTestCase();
			assert(test is TestCase);
			assert(test.suite != null);
		});

		GLib.Test.add_func ("/testcase/add_test", () => {
			TestCase test = new TestTestCase();
			test.add_test("add_test", ()=> { assert(true); });
			assert(test is TestCase);
		});

		GLib.Test.add_func ("/textrunner/new", () => {
			string testexe = Config.VALADATE_TESTS_DIR +"/libvaladate/data/.libs/lt-testexe";
			TextRunner runner = new TextRunner(testexe);
			assert(runner is TextRunner);
		});

		GLib.Test.add_func ("/textrunner/load_module", () => {
			string testexe = Config.VALADATE_TESTS_DIR +"/libvaladate/data/.libs/lt-testexe";
			TextRunner runner = new TextRunner(testexe);
			try {
				runner.load_module();
			} catch (RunError err) {
				debug(err.message);
				assert_not_reached();
			}
		});

		GLib.Test.add_func ("/textrunner/load_gir", () => {
			string testexe = Config.VALADATE_TESTS_DIR +"/libvaladate/data/.libs/lt-testexe";
			TextRunner runner = new TextRunner(testexe);
			try {
				runner.load_module();
				runner.load_gir();
			} catch (RunError err) {
				debug(err.message);
				assert_not_reached();
			}
		});

		GLib.Test.add_func ("/textrunner/load_tests", () => {
			string testexe = Config.VALADATE_TESTS_DIR +"/libvaladate/data/.libs/lt-testexe";
			TextRunner runner = new TextRunner(testexe);
			assert(runner.tests.length == 0);
			try {
				runner.load_module();
				runner.load_gir();
				runner.load_tests();
			} catch (RunError err) {
				debug(err.message);
				assert_not_reached();
			}
			assert(runner.tests.length == 1);
			assert(((TestCase)runner.tests[0]).name == "ValadateTestExe");
		});

		GLib.Test.add_func ("/textrunner/load", () => {
			string testexe = Config.VALADATE_TESTS_DIR +"/libvaladate/data/.libs/lt-testexe";
			TextRunner runner = new TextRunner(testexe);
			assert(runner.tests.length == 0);
			try {
				runner.load();
			} catch (RunError err) {
				debug(err.message);
				assert_not_reached();
			}
			assert(runner.tests.length == 1);
			assert(((TestCase)runner.tests[0]).name == "ValadateTestExe");
		});


		GLib.TestSuite.get_root().add_suite(new TempDirTest().suite);

		GLib.Test.run ();

	}
}
