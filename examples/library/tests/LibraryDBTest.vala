namespace Library {

using Library;

	public class LibraryDBTest : TestCase {

		private LibraryDB db;

		public void setUp() {
			db = new MockLibraryDB();
			db.addBook(new Book( "Cosmos", "Carl Sagan" ));
			db.addBook(new Book( "Contact", "Carl Sagan" ));
		}

		public void testGetBook() {
			Book book = db.getBook( "Cosmos", "Carl Sagan" );
			assertEquals( "Cosmos", book.getTitle() );
			assertEquals( "Carl Sagan", book.getAuthor() );
		}

		public void testGetBooksByTitle() {
			Vector books = db.getBooksByTitle( "Cosmos" );
			assertEquals( 1, books.size() );
			Book book = (Book)books.elementAt(0);
			assertEquals( "Cosmos", book.getTitle() );
		}

		public void testGetBooksByAuthor() {
			Vector books = db.getBooksByAuthor( "Carl Sagan" );
			assertEquals( 2, books.size() );
			Book book1 = (Book)books.elementAt(0);
			assertEquals( "Cosmos", book1.getTitle() );
			Book book2 = (Book)books.elementAt(1);
			assertEquals( "Contact", book2.getTitle() );
		}

	}
}
