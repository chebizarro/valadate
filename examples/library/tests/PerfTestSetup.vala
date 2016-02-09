// TestSetup for performance test

namespace Library {

	public class PerfTestSetup extends TestSetup {

		private static Library library;

		PerfTestSetup(Test test) { super(test); }

		public static Library getLibrary() { return library; }

		public void setUp() throws Exception {
			library = new Library();
			for ( int i=0; i < 100000; i++ ) {
				String title = "book" + i;
				String author = "author" + i;
				library.addBook(new Book( title, author ));
			}
		}

		public void tearDown() {
			library = null;
		}
	}
}
