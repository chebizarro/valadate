namespace Library {

	using Gee;
	using Valadate;
	
	public class LibraryTest : Valadate.TestCase {

		private Library library;

		public override void set_up() {
			this.library = new Library();
			try {
				library.add_book(new Book( "Cosmos", "Carl Sagan" ));
				library.add_book(new Book( "Contact", "Carl Sagan" ));
				library.add_book(new Book( "Solaris", "Stanislaw Lem" ));
				library.add_book(new Book( "American Beauty", "Allen M Steele" ));
				library.add_book(new Book( "American Beauty", "Edna Ferber" ));
			} catch (Exception e) {
				debug(e.message);
			}
		}

		[Test (name="get_books_by_title")]
		public void testGetBooksByTitle() {
			ArrayList<Book> books = this.library.get_books_by_title( "American Beauty" );
			Assert.equals(2, books.size, "wrong number of books found");
		}

		[Test (name="get_books_by_author")]
		public void testGetBooksByAuthor() {
			ArrayList<Book> books = library.get_books_by_author("Carl Sagan");
			Assert.equals(2, books.size, "2 books not found");
		}

		[Test (name="get_books_by_title_and_author")]
		public void testGetBookByTitleAndAuthor() {
			Book book = library.get_book("Cosmos", "Carl Sagan");
			Assert.not_null(book, "book not found");
		}
		
		[Test (name="get_non_existent_book")]
		public void testGetNonexistentBook() {
			Book book = library.get_book( "Nonexistent", "Nobody" );
			Assert.null(book, "Nonexistent book found");
		}

		[Test (name="get_non_existent_book_by_title")]
		public void testGetNonexistentBookByTitle() {
			ArrayList<Book> books = library.get_books_by_title("Nonexistent");
			Assert.equals(0, books.size, "Nonexistent book found");
		}
		
		[Test (name="get_non_existent_book_by_author")]
		public void testGetNonexistentBookByAuthor() {
			ArrayList<Book> books = library.get_books_by_author("Nobody");
			Assert.equals(0, books.size, "Book by Nobody found");
		}

		[Test (name="library_size")]
		public void testLibrarySize() {
			Assert.equals(5, library.get_num_books(), "Wrong number of books" );
		}


		[Test (name="remove_book")]
		public void testRemoveBook() {
			try {
				library.remove_book("Cosmos", "Carl Sagan");
			} catch (Exception e) {
				Assert.fail(e.message);
			}
			Book book = library.get_book( "Cosmos", "Carl Sagan" );
			Assert.null(book, "book is not removed");
		}

		[Test (name="remove_non_existent_book")]
		public void testRemoveNonexistentBook() {
			try {
				library.remove_book( "Nonexistent", "Nobody" );
				Assert.fail( "Expected exception not thrown" );
			} catch (Exception e) {
				Assert.equals (e.message, "Book title: Nonexistent not found");
			}
		}

		[Test (name="create_duplicate_book")]
		public void testCreateDuplicateBook() {
			try {
				library.add_book(new Book("Cosmos", "Carl Sagan"));
				Assert.fail("Expected exception not thrown");
			} catch (Exception e) {
				Assert.equals (e.message, "Duplicate Book");
			}
		}

		[Test (name="enumeration")]
		public void testEnumeration() {
			int count = 0;
			foreach (Book book in library)
				count++;
			Assert.equals(5, count);
		}

		[Test (name="empty")]
		public void testEmpty() {
			library.empty();
			Assert.equals(0, library.get_num_books(), "library not empty");
		}
	}

}
