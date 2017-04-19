namespace Valadate.Tests {


	public class ConcreteAssembly : Assembly {
		
		public class ConcreteAssembly(File binary) {
			base(binary);
		}
		
		public override Assembly clone() {
			return new ConcreteAssembly(binary) as Assembly;
		}
		
	}

	public class MockTestCase : TestCase {
		
		construct {
			add_test_method("mocktest", test_test, 10000, "mock test");
		}
		
		public void test_test() {
			assert(true);
		}
	}



}
