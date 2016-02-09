namespace Library.Gui {

	using Library;

	public class AddBook {

		private Library library;

		public AddBook(Library lib) {
			library = lib;
		}

		public boolean add(String title, string author) {
			Book book = new Book( title, author );
			try {
				library.addBook( book );
				return true;
			} catch (Exception e) {
				return false;
			}
		}

	}
}
