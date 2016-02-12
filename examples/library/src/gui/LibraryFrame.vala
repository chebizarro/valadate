using Library;

namespace Library.Gui {

	public class LibraryFrame {

		private Library library;
		public AddBook addBook;
		public FindBookByTitle findBookByTitle;

		public LibraryFrame(Library lib) {
			library = lib;
			addBook = new AddBook(library);
			findBookByTitle = new FindBookByTitle(library);
		}

	}
}
