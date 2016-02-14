namespace Library {

	using Gee;

	public interface LibraryDB : Object {
		public abstract void add_book(Book book);
		public abstract Book? get_book(string title, string author);
		public abstract ArrayList<Book> get_books_by_title(string title);
		public abstract ArrayList<Book> get_books_by_author(string author);
	}
}
