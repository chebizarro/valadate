namespace Library {

	public class MockLibraryDB : LibraryDB {

		MockLibraryDB() {
			books = new Vector();
		}

		public void addBook( Book book ) {
			books.add( book );
		}

		public Book getBook( String title, String author ) {
			for ( int i=0; i < books.size(); i++ ) {
				Book book = (Book) books.elementAt( i );
				if ( book.getTitle().equals(title)
				  && book.getAuthor().equals(author) )
					return book;
			}
			return null;
		}

		public Vector getBooksByTitle( String title ) {
			Vector title_books = new Vector();
			for ( int i=0; i < books.size(); i++ ) {
				Book book = (Book) books.elementAt( i );
				if ( book.getTitle().equals(title) )
					title_books.add( book );
			}
			return title_books;
		}

		public Vector getBooksByAuthor( String author ) {
			Vector auth_books = new Vector();
			for ( int i=0; i < books.size(); i++ ) {
				Book book = (Book) books.elementAt( i );
				if ( book.getAuthor().equals(author) ) 
					auth_books.add( book );
			}
			return auth_books;   
		}

		private Vector books;

	}
}
