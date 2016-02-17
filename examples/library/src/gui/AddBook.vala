using Library;

namespace Library.Gui {

	public class AddBook {

		private Library library;

		public AddBook(Library lib) {
			library = lib;
		}

		public bool add(string title, string author) {
			Book book = new Book( title, author );
			try {
				library.add_book( book );
				return true;
			} catch (Exception e) {
				return false;
			}
		}

	}
}
