using Library;
using Gee;

namespace Library.Gui {

	public class FindBookByTitle {

		private Library library;
		private Book foundBook;
		protected FindBookByTitleView view;

		FindBookByTitle(Library lib) {
			library = lib;
			foundBook = null;
		}

		public Book getFoundBook() { return foundBook; }

		protected void find( string title ) {
			ArrayList<Book> books = library.getBooksByTitle( title );
			if ( books.size() == 0 ) {
				foundBook = null;
			} else {
				foundBook = (Book)books.elementAt(0);
				BookView bookView = new BookView( foundBook );
				bookView.show();
			}
		}
	}
}
