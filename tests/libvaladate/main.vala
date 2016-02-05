namespace Valadate {

	void add_tests () {
		GLib.Test.add_func ("/libvaladate/testcase/new", () => {
			//TestCase test = new TestCase("TestTestCase");
			//assert(test is GLib.TestCase);
		});
	}

	void main (string[] args) {
		GLib.Test.init (ref args);
		add_tests ();
		GLib.Test.run ();
	}

}
