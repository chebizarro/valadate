namespace Library.Gui {

	using Library;

	public class FindBookByTitleViewTest : BaseViewTestCase {

		private Library library;
		private FindBookByTitle findBook;
		private FindBookByTitleView view;

		public BaseView getBaseView() {
			return new FindBookByTitleView( findBook );
		}

		public void setUp() throws Exception {
			library = new Library();
			Book book = new Book("Solaris", "Stanislaw Lem");
			library.addBook( book );
			findBook = new FindBookByTitle(library);
			view = (FindBookByTitleView)getBaseView();
			view.show();
		}

		public void tearDown() {
			findBook = null;
			library = null;
		}

		public void testControlValues() {
			assertEquals( "", view.titleField.getText() );
			assertEquals( "", view.msgField.getText() );
			assertEquals( "Find", view.findButton.getText() );
		}

		public void testFindButton() {
			view.titleField.setText("Solaris");
			view.findButton.doClick();
			assertEquals( "", view.msgField.getText() );
		}

		public void testFindNonexistentBook() {
			view.titleField.setText("Nonexistent");
			view.findButton.doClick();
			assertFalse( view.msgField.getText().equals("") );
		}

		public void testCancelButton() {
			view.cancelButton.doClick();
			assertFalse( view.isVisible() );
		}
	}
}
