namespace Library {

	using Gee;
	using Valadate;
	
	public class LibraryTest : Valadate.TestCase {

		private Library library;

		public override void set_up() {
			library = new Library();
			library.add_book(new Book( "Cosmos", "Carl Sagan" ));
			library.add_book(new Book( "Contact", "Carl Sagan" ));
			library.add_book(new Book( "Solaris", "Stanislaw Lem" ));
			library.add_book(new Book( "American Beauty", "Allen M Steele" ));
			library.add_book(new Book( "American Beauty", "Edna Ferber" ));
		}

		[Test (name="get_books_by_title")]
		public void testGetBooksByTitle() {
			ArrayList<Book> books = library.get_books_by_title( "American Beauty" );
			//assertEquals( "wrong number of books found", 2, books.size() );
			assert(books.size == 2 );
		}

		public void testGetBooksByAuthor() {
			ArrayList<Book> books = library.getBooksByAuthor( "Carl Sagan" );
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
			ArrayList<Book> books = library.getBooksByTitle( "Nonexistent" );
			assertEquals( "Nonexistent book found", 0, books.size() );
		}

		public void testGetNonexistentBookByAuthor() {
			ArrayList<Book> books = library.getBooksByAuthor( "Nobody" );
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
				library.add_book(new Book( "Cosmos", "Carl Sagan" ));
				fail( "Expected exception not thrown" );
			} catch (Exception e) {
			}
		}

		public void testEnumeration() {
			int count = 0;
			foreach (Book book in library.iterator()) {
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
