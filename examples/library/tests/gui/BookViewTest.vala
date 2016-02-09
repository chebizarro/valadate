namespace Library.Gui {

	using Library;

	public class BookViewTest extends TestCase {

		private BookView view;

		public void setUp() {
			Book book = new Book("Cosmos", "Carl Sagan");
			view = new BookView( book );
			view.show();
		}

		public void tearDown() {
			view.dispose();
		}

		public void testTitle() {
			assertEquals( "Book", view.getTitle() );
		}

		public void testControlValues() {
			assertEquals( "Cosmos", view.titleField.getText() );
			assertEquals( "Carl Sagan", view.authorField.getText() );
		}

	}
}
