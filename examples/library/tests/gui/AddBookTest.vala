using Library;

namespace Library.Gui {

	using Valadate;

	public class AddBookTest : Valadate.TestCase {

		private AddBook addBook;
		private Library library;

		public override void set_up() {
			library = new Library();
			addBook = new AddBook(library);
		}

		public override void tear_down() {
			addBook = null;
			library = null;
		}

		[Test (name="add_book")]
		public void testAddBook() {
			addBook.add("The Dragons of Eden", "Carl Sagan");
			Assert.equals(1, library.get_books_by_title("The Dragons of Eden").size);
		}

		[Test (name="add_duplicate_book")]
		public void testAddDuplicateBook() {
			Assert.is_true(addBook.add( "Solaris", "Stanislaw Lem" ));
			Assert.is_false(addBook.add( "Solaris", "Stanislaw Lem" ));
		}
	}
}
