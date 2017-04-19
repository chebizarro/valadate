namespace Valadate.Tests {

	public static void new_test_result() {
		var options = new TestOptions({ testbinary.get_path() });
		var conf = new TestConfig(options);
		var res = new TestResult(conf);
		
		assert(res is TestResult);
	}

	public static void test_result_add_test() {
		var options = new TestOptions({ testbinary.get_path() });
		var conf = new TestConfig(options);
		var res = new TestResult(conf);
		
		var test = new MockTestCase();
		res.add_test(test);
	
		assert(test.count == 1);
	}
	
	// report
	// add_error
	// add_failure
	// add_success
	// add_skip
	// 

	private const string buffer1 = 
"""<failure message="test.vala:43: This is just info" type="G_LOG_LEVEL_INFO">
G_LOG_LEVEL_INFO: test.vala:43: This is just info
</failure>
This is a stderr message""";

	public static void test_result_process_buffers() {
		var options = new TestOptions({ testbinary.get_path() });
		var conf = new TestConfig(options);
		var res = new TestResult(conf);
		
		var test = new MockTestCase();
		res.add_test(test);

		//res.process_buffer(test, buffer1);

	}
	
}
