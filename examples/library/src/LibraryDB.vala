namespace Library {

	public interface LibraryDB {
		void addBook( Book book );
		Book getBook( string title, string author );
		Vector getBooksByTitle( string title );
		Vector getBooksByAuthor( string author );
	}
}
