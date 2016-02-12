namespace Library {

	using Gee;

	public class Library {

		private HashSet booksById;
		private HashSet bookIdsByAuthor;
		private HashSet bookIdsByTitle;
		private static int nextBookId; 

		public Library() {
			booksById = new HashSet();
			bookIdsByAuthor = new HashSet();
			bookIdsByTitle = new HashSet();
			nextBookId = 0;
		}

		public void addBook( Book book ) throws Exception {
			ArrayList<Book> titleIds = (ArrayList<Book>)bookIdsByTitle.get( book.getTitle() );
			ArrayList<Book> authorIds = (ArrayList<Book>)bookIdsByAuthor.get( book.getAuthor() );
			if ( titleIds != null && authorIds != null ) {
				if ( intersection( titleIds, authorIds ) != null )
					throw new Exception("Duplicate Book");
			}
			if ( titleIds == null )
				titleIds = new ArrayList<Book>();
			if ( authorIds == null )
				authorIds = new ArrayList<Book>();
			nextBookId++;
			int id = new Integer( nextBookId );
			titleIds.add( id );
			bookIdsByTitle.put( book.getTitle(), titleIds );
			authorIds.add( id );
			bookIdsByAuthor.put( book.getAuthor(), authorIds );
			booksById.put( id, book );
		}

		public Book getBook( string title, string author ) {
			ArrayList<Book> titleIds = (ArrayList<Book>)bookIdsByTitle.get( title );
			if ( titleIds == null )
				return null;
			ArrayList<Book> authorIds = (ArrayList<Book>)bookIdsByAuthor.get( author );
			if ( authorIds == null )
				return null;
			int id = (int)intersection( titleIds, authorIds );
			if ( id == null )
				return null;
			return (Book)booksById.get( id );
		}

		public ArrayList<Book> getBooksByTitle( string title ) {
			ArrayList<Book> books = new ArrayList<Book>();
			ArrayList<Book> titleIds = (ArrayList<Book>)bookIdsByTitle.get( title );
			if ( titleIds == null ) 
				return books;
			for ( Enumeration e = titleIds.elements(); 
					e.hasMoreElements(); ) {
				int id = (int)e.nextElement();
				Book book = (Book)booksById.get( id );
				books.add( book );
			}
			return books;
		}

		public ArrayList<Book> getBooksByAuthor( string author ) {
			ArrayList<Book> books = new ArrayList<Book>();
			ArrayList<Book> authorIds = (ArrayList<Book>)bookIdsByAuthor.get( author );
			if ( authorIds == null )
				return books;
			for ( Enumeration e = authorIds.elements(); 
					e.hasMoreElements(); ) {
				int id = (int)e.nextElement();
				Book book = (Book)booksById.get( id );
				books.add( book );
			}
			return books;   
		}

		public void removeBook( string title, string author ) throws Exception {
			ArrayList<Book> titleIds = (ArrayList<Book>)bookIdsByTitle.get( title );
			if ( titleIds == null )
				throw new Exception("Book not found");
			ArrayList<Book> authorIds = (ArrayList<Book>)bookIdsByAuthor.get( author );
			if ( authorIds == null ) {
				throw new Exception("Book not found");
			}
			int id = (int)intersection( titleIds, authorIds );
			if ( titleIds.size() == 1 )
				bookIdsByTitle.remove( title );
			else {
				titleIds.remove( id );
				bookIdsByTitle.put( title, titleIds );
			}
			if ( authorIds.size() == 1 )
				bookIdsByAuthor.remove( author );
			else {	
				authorIds.remove( id );
				bookIdsByAuthor.put( author, authorIds );
			}
			if ( booksById.remove( id ) == null )
				throw new Exception("Book not found");
		}

		public Enumeration elements() {
			return booksById.elements();
		}

		public int getNumBooks() {
			return booksById.size();
		}

		public void empty() {
			booksById.clear();
			bookIdsByTitle.clear();
			bookIdsByAuthor.clear();
			nextBookId = 0;
		}

		private Object intersection(ArrayList<Book> v1, ArrayList<Book> v2) {
			Iterator iter = v1.iterator();
			while ( iter.hasNext() )
			{
				Object obj = iter.next();
				if ( v2.contains( obj ) )
					return obj;
			}
			return null;
		}
	}
}
