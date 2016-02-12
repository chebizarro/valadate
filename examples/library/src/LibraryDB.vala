namespace Library {

	using Gee;

	public interface LibraryDB {
		void addBook( Book book );
		Book getBook( string title, string author );
		ArrayList<Book> getBooksByTitle( string title );
		ArrayList<Book> getBooksByAuthor( string author );
	}
}
