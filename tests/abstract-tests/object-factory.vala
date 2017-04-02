namespace Valadate.Tests {

	public errordomain FactoryError {
		NOT_FOUND
	}


	public class TestObject : Object {
		
		public string name {get;construct set;}
		
	}

	public class ObjectFactory : Object {
	
		private string[] objects = { "yak", "goat", "chicken", "duck", "dog" };
	
		public TestObject get_object(string name) throws FactoryError {
			if(!(name in objects))
				throw new FactoryError.NOT_FOUND("The object %s was not found!", name);
			return Object.new(typeof(TestObject), "name", name) as TestObject;
		}
	
	}

}
