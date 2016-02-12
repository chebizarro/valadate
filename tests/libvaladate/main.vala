namespace Valadate.Tests {

	public class TestTestCase : TestCase {
		
		/*
		public TestTestCase(string name) {
			base(name);
		}
		*/
		
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


		GLib.TestSuite.get_root().add_suite(new TempDirTest().suite);

		GLib.Test.run ();

	}
}
