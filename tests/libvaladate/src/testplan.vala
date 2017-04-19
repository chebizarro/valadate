namespace Valadate.Tests {

	public static void new_test_plan() {
		
		var assembly = new TestAssembly({ testbinary.get_path() });
		
		var tplan = TestPlan.new(assembly); 
		
		assert(tplan is TestPlan);
	}



}
