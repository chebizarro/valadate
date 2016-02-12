namespace Library.Gui {

	using Library;

	public class AddBookViewTest : BaseViewTestCase {

		private Library library;
		private AddBook addBook;
		private AddBookView view;

		public BaseView getBaseView() {
			return new AddBookView( addBook );
		}

		public void setUp() {
			library = new Library();
			addBook = new AddBook( library );
			view = (AddBookView)getBaseView();
			view.show();
		}

		public void tearDown() {
			addBook = null;
			library = null;
		}

		public void testControlValues() {
			assertEquals( "Add Book", view.getTitle() );
			assertEquals( "", view.titleField.getText() );
			assertEquals( "", view.authorField.getText() );
			assertEquals( "Add", view.addButton.getText() );
			assertEquals( "Cancel", view.cancelButton.getText() );
		}

		public void testAddButton() {
			view.titleField.setText("The Dragons of Eden");
			view.authorField.setText("Carl Sagan");
			view.addButton.doClick();
			assertEquals(1, library.getBooksByTitle("The Dragons of Eden").size());
			assertEquals( "", view.titleField.getText() );
			assertEquals( "", view.authorField.getText() );
			assertFalse( view.isVisible() );
		}

		public void testCancelButton() {
			view.cancelButton.doClick();
			assertEquals( 0, library.getNumBooks() );
			assertEquals( "", view.titleField.getText() );
			assertEquals( "", view.authorField.getText() );
			assertFalse( view.isVisible() );
		}

		public void testAddDuplicateBook() {
			addBook.add( "Solaris", "Stanislaw Lem" );
			view.titleField.setText("Solaris");
			view.authorField.setText("Stanislaw Lem");
			view.addButton.doClick();
			assertEquals( "Solaris", view.titleField.getText() );
			assertEquals( "Stanislaw Lem", view.authorField.getText() );
			assertTrue( view.isVisible() );
		}
	}
}
