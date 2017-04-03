namespace Valadate {

	public int main (string[] args) {

		try {
			Module.load_all();
			var options = new TestOptions(args);
			var testplan = TestPlan.new(options);
			testplan.run();
		} catch (Error e) {
			error(e.message);
		}
		return 0;
	}
}
