namespace Valadate {

	public int main (string[] args) {

		try {
			
			Module.load_all();
			var options = new TestOptions(args);
			var testplan = TestPlan.new(options);
			var runner = new TestRunner(testplan);
			runner.run_all();
			
		} catch (Error e) {
			error(e.message);
		}

		return 0;
		
	}
}
