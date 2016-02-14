namespace Library {

	using Gee;

	public class MockLibraryDB : Object, LibraryDB {

		public MockLibraryDB() {
			books = new ArrayList<Book>();
		}

		public void add_book( Book book ) {
			books.add( book );
		}

		public Book? get_book(string title, string author) {
			foreach (Book book in books)
				if (book.title == title && book.author == author)
					return book;
			return null;
		}

		public ArrayList<Book> get_books_by_title(string title) {
			ArrayList<Book> title_books = new ArrayList<Book>();
			foreach (Book book in books)
				if (book.title == title)
					title_books.add( book );
			return title_books;
		}

		public ArrayList<Book> get_books_by_author(string author) {
			ArrayList<Book> auth_books = new ArrayList<Book>();
			foreach (Book book in books)
				if (book.author == author)
					auth_books.add(book);
			return auth_books;
		}

		private ArrayList<Book> books;

	}
}
