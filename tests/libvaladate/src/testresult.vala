namespace Valadate.Tests {

	public class MockTestCase : TestCase {
		
		construct {
			add_test_method("mocktest", test_test, "mock test");
		}
		
		public void test_test() {
			assert(true);
		}
	}


	public static void new_test_result() {
		string binary = Path.build_filename(Config.VALADATE_TESTS_DIR, "..", "data", ".libs", "testexe-0");
		var options = new TestOptions({ binary });
		var conf = new TestConfig(options);
		var res = new TestResult(conf);
		
		assert(res is TestResult);
	
	}

	public static void test_result_add_test() {
		string binary = Path.build_filename(Config.VALADATE_TESTS_DIR, "..", "data", ".libs", "testexe-0");
		var options = new TestOptions({ binary });
		var conf = new TestConfig(options);
		var res = new TestResult(conf);
		
		var test = new MockTestCase();
		res.add_test(test);
	
		assert(test.count == 1);
	
	}

	private const string buffer1 = """<failure message="test.vala:43: This is just info" type="G_LOG_LEVEL_INFO">
G_LOG_LEVEL_INFO: test.vala:43: This is just info
</failure>
This is a stderr message""";



	public static void test_result_process_buffer() {
		string binary = Path.build_filename(Config.VALADATE_TESTS_DIR, "..", "data", ".libs", "testexe-0");
		var options = new TestOptions({ binary });
		var conf = new TestConfig(options);
		var res = new TestResult(conf);
		
		var test = new MockTestCase();
		res.add_test(test);

		//res.process_buffer(test, buffer1);

	}
	
}
