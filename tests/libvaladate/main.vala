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
			assert(runner.tests.length == 2);
			assert(((TestCase)runner.tests[0]).name == "ValadateTestExe");
			assert(((TestCase)runner.tests[1]).name == "ValadateTestExeTwo");
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
			assert(runner.tests.length == 2);
			assert(((TestCase)runner.tests[0]).name == "ValadateTestExe");
			assert(((TestCase)runner.tests[1]).name == "ValadateTestExeTwo");
		});

		GLib.Test.add_func ("/assert/equals/string", () => {
			string t1 = "test";
			string t2 = "test";
			
			Assert.equals(t1, t2, "Values must be equal");
		});

		GLib.Test.add_func ("/assert/equals", () => {
			GLib.Test.trap_subprocess("/assert/equals/subprocess", 0,0);
			GLib.Test.trap_assert_failed();
		});

		GLib.Test.add_func ("/assert/equals/subprocess", () => {
			Assert.equals(24, 23, "Values must be equal");
		});

		GLib.Test.add_func ("/assert/null", () => {
			void* nullval = null;
			Assert.null(nullval, "Value must be null");
		});

		GLib.Test.add_func ("/assert/null/fail", () => {
			GLib.Test.trap_subprocess("/assert/null/fail/subprocess", 0,0);
			GLib.Test.trap_assert_failed();
		});

		GLib.Test.add_func ("/assert/null/fail/subprocess", () => {
			string nullval = "test";
			Assert.null(nullval, "Value must be null");
		});

		GLib.Test.add_func ("/assert/not_null", () => {
			string nullval = "test";
			Assert.not_null(nullval, "Value must not be null");
		});

		GLib.Test.add_func ("/assert/not_null/fail", () => {
			GLib.Test.trap_subprocess("/assert/not_null/fail/subprocess", 0,0);
			GLib.Test.trap_assert_failed();
		});

		GLib.Test.add_func ("/assert/not_null/fail/subprocess", () => {
			void* nullval = null;
			Assert.not_null(nullval, "Value must not be null");
		});

		//GLib.TestSuite.get_root().add_suite(new TempDirTest().suite);

		GLib.Test.run ();

	}
}
