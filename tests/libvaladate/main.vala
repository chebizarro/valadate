namespace Valadate {

	void add_tests () {
		Test.add_func ("/libvaladate/testcase/new", () => {
			TestCase test = new TestCase("TestTestCase");
			assert(test is TestCase);
		});
	}

	void main (string[] args) {
		Test.init (ref args);
		add_tests ();
		Test.run ();
	}

}
