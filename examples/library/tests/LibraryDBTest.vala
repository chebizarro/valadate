namespace Library {

	using Valadate;
	using Gee;
	
	public class LibraryDBTest : Valadate.TestCase {

		private LibraryDB db;

		public override void set_up() {
			db = new MockLibraryDB();
			db.add_book(new Book( "Cosmos", "Carl Sagan" ));
			db.add_book(new Book( "Contact", "Carl Sagan" ));
		}

		[Test (name="get_book")]
		public void testGetBook() {
			Book book = db.get_book( "Cosmos", "Carl Sagan" );
			Assert.equals( "Cosmos", book.title );
			Assert.equals( "Carl Sagan", book.author );
		}

		[Test (name="get_books_by_title")]
		public void testGetBooksByTitle() {
			ArrayList<Book> books = db.get_books_by_title( "Cosmos" );
			Assert.equals(1, books.size);
			Book book = books.get(0);
			Assert.equals("Cosmos", book.title);
		}

		[Test (name="get_books_by_author")]
		public void testGetBooksByAuthor() {
			ArrayList<Book> books = db.get_books_by_author( "Carl Sagan" );
			Assert.equals(2, books.size);
			Book book1 = books.get(0);
			Assert.equals("Cosmos", book1.title);
			Book book2 = books.get(1);
			Assert.equals("Contact", book2.title);
		}

	}
}
