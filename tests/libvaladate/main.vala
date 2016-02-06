namespace Valadate {

	public class TestTestCase : TestCase {
		
		public TestTestCase(string name) {
			base(name);
		}
		
	}

	void main (string[] args) {
		GLib.Test.init (ref args);

		GLib.Test.add_func ("/libvaladate/testcase/new", () => {
			TestCase test = new TestTestCase("TestTestCase");
			assert(test is TestCase);
			assert(test.suite != null);
		});

		GLib.Test.add_func ("/libvaladate/testcase/add_test", () => {
			TestCase test = new TestTestCase("TestTestCase");
			test.add_test("add_test", ()=> { assert(true); });
			assert(test is TestCase);
		});

		GLib.Test.run ();
	}
}
