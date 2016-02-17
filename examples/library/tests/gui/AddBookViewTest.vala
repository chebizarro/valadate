using Library;
using Valadate;

namespace Library.Gui {

	public class AddBookViewTest : BaseViewTestCase {

		private Library library;
		private AddBook addBook;
		private AddBookView view;

		public override BaseView getBaseView() {
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
			Assert.equals("Add Book", view.title );
			Assert.equals("", view.title_field.get_text() );
			Assert.equals("", view.author_field.get_text() );
			Assert.equals("Add", view.add_button.label);
			Assert.equals("Cancel", view.cancel_button.label);
		}

		public void testAddButton() {
			view.title_field.set_text("The Dragons of Eden");
			view.author_field.set_text("Carl Sagan");
			view.add_button.clicked();
			Assert.equals(1, library.get_books_by_title("The Dragons of Eden").size);
			Assert.equals("", view.title_field.get_text() );
			Assert.equals("", view.author_field.get_text() );
			Assert.is_false(view.visible);
		}

		public void testCancelButton() {
			view.cancel_button.clicked();
			Assert.equals(0, library.get_num_books());
			Assert.equals("", view.title_field.get_text());
			Assert.equals("", view.author_field.get_text());
			Assert.is_false(view.visible);
		}

		public void testAddDuplicateBook() {
			addBook.add( "Solaris", "Stanislaw Lem" );
			view.title_field.set_text("Solaris");
			view.author_field.set_text("Stanislaw Lem");
			view.add_button.clicked();
			Assert.equals("Solaris", view.title_field.get_text() );
			Assert.equals("Stanislaw Lem", view.author_field.get_text() );
			Assert.is_true(view.visible);
		}
	}
}
