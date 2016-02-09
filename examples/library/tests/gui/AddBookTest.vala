namespace Library.Gui {

	using Library;

	public class AddBookTest extends TestCase {

		private AddBook addBook;
		private Library library;

		public void setUp() {
			library = new Library();
			addBook = new AddBook(library);
		}

		public void tearDown() {
			addBook = null;
			library = null;
		}

		public void testAddBook() {
			addBook.add("The Dragons of Eden", "Carl Sagan");
			assertEquals( 1, 
				library.getBooksByTitle("The Dragons of Eden").size() );
		}

		public void testAddDuplicateBook() {
			assertTrue( addBook.add( "Solaris", "Stanislaw Lem" ) );
			assertFalse( addBook.add( "Solaris", "Stanislaw Lem" ) );
		}
	}
}
