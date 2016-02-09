namespace Library.Gui {

	using Library;

	public class FindBookByTitleTest extends TestCase {

		private FindBookByTitle findBook;
		private Library library;

		public void setUp() throws Exception {
			library = new Library();
			Book book = new Book( "Cosmos", "Carl Sagan" );
			library.addBook( book );
			findBook = new FindBookByTitle(library);
		}

		public void tearDown() {
		}

		public void testFind() {
			findBook.find("Cosmos");
			Book book = findBook.getFoundBook();
			assertEquals( "Cosmos", book.getTitle() );
		}

		public void testFindNonexistentBook() {
			findBook.find("Nonexistent");
			Book book = findBook.getFoundBook();
			assertNull( book );
		}

	}
}
