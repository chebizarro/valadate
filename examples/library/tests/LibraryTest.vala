namespace Library {

	public class LibraryTest : TestCase {

		private Library library;

		public void setUp() throws Exception {
			library = new Library();
			library.addBook(new Book( "Cosmos", "Carl Sagan" ));
			library.addBook(new Book( "Contact", "Carl Sagan" ));
			library.addBook(new Book( "Solaris", "Stanislaw Lem" ));
			library.addBook(new Book( "American Beauty", "Allen M Steele" ));
			library.addBook(new Book( "American Beauty", "Edna Ferber" ));
		}

		public void tearDown() {
		}

		public void testGetBooksByTitle() {
			Vector books = library.getBooksByTitle( "American Beauty" );
			assertEquals( "wrong number of books found", 2, books.size() );
		}

		public void testGetBooksByAuthor() {
			Vector books = library.getBooksByAuthor( "Carl Sagan" );
			assertEquals( "2 books not found", 2, books.size() );
		}

		public void testGetBookByTitleAndAuthor() {
			Book book = library.getBook( "Cosmos", "Carl Sagan" );
			assertNotNull( "book not found", book );
		}

		public void testGetNonexistentBook() {
			Book book = library.getBook( "Nonexistent", "Nobody" );
			assertNull( "Nonexistent book found", book );
		}

		public void testGetNonexistentBookByTitle() {
			Vector books = library.getBooksByTitle( "Nonexistent" );
			assertEquals( "Nonexistent book found", 0, books.size() );
		}

		public void testGetNonexistentBookByAuthor() {
			Vector books = library.getBooksByAuthor( "Nobody" );
			assertEquals( "Book by Nobody found", 0, books.size() );
		}

		public void testLibrarySize() {
			assertEquals( "Wrong number of books", 5, library.getNumBooks() );
		}

		public void testRemoveBook() {
			try {
				library.removeBook( "Cosmos", "Carl Sagan" );
			} catch (Exception e) {
				fail( e.getMessage() );
			}
			Book book = library.getBook( "Cosmos", "Carl Sagan" );
			assertNull( "book is not removed", book );
		}

		public void testRemoveNonexistentBook() {
			try {
				library.removeBook( "Nonexistent", "Nobody" );
				fail( "Expected exception not thrown" );
			} catch (Exception e) {
			}
		}

		public void testCreateDuplicateBook() {
			try {
				library.addBook(new Book( "Cosmos", "Carl Sagan" ));
				fail( "Expected exception not thrown" );
			} catch (Exception e) {
			}
		}

		public void testEnumeration() {
			int count = 0;
			for (Enumeration e = library.elements();
				  e.hasMoreElements(); ) {
				Book book = (Book)e.nextElement();
				count++;
			}
			assertEquals(5, count);
		}

		public void testEmpty() {
			library.empty();
			assertEquals( "library not empty", 0, library.getNumBooks() );
		}

	}

}
