namespace Valadate.Tests {

	public class ConcreteTests : AbstractTests {
	
		construct {
			mysteryanimal = "duck";
		}

		public override void test_get_dog() {
			
			var dog = factory.get_object("dog");
			
			assert(dog is TestObject);
			assert(dog.name == "dog");
		}

	
	}

}
