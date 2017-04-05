namespace Valadate {

	public static void main (string[] args) {
		try {
			var assembly = new TestAssembly(args);
			var testplan = TestPlan.new(assembly);
			testplan.run();
		} catch (Error e) {
			error(e.message);
		}
	}
}
