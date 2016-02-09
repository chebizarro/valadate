namespace Library {


	public class Library {

		private Hashtable booksById;
		private Hashtable bookIdsByAuthor;
		private Hashtable bookIdsByTitle;
		private static int nextBookId; 

		public Library() {
			booksById = new Hashtable();
			bookIdsByAuthor = new Hashtable();
			bookIdsByTitle = new Hashtable();
			nextBookId = 0;
		}

		public void addBook( Book book ) throws Exception {
			Vector titleIds = (Vector)bookIdsByTitle.get( book.getTitle() );
			Vector authorIds = (Vector)bookIdsByAuthor.get( book.getAuthor() );
			if ( titleIds != null && authorIds != null ) {
				if ( intersection( titleIds, authorIds ) != null )
					throw new Exception("Duplicate Book");
			}
			if ( titleIds == null )
				titleIds = new Vector();
			if ( authorIds == null )
				authorIds = new Vector();
			nextBookId++;
			Integer id = new Integer( nextBookId );
			titleIds.add( id );
			bookIdsByTitle.put( book.getTitle(), titleIds );
			authorIds.add( id );
			bookIdsByAuthor.put( book.getAuthor(), authorIds );
			booksById.put( id, book );
		}

		public Book getBook( string title, string author ) {
			Vector titleIds = (Vector)bookIdsByTitle.get( title );
			if ( titleIds == null )
				return null;
			Vector authorIds = (Vector)bookIdsByAuthor.get( author );
			if ( authorIds == null )
				return null;
			Integer id = (Integer)intersection( titleIds, authorIds );
			if ( id == null )
				return null;
			return (Book)booksById.get( id );
		}

		public Vector getBooksByTitle( string title ) {
			Vector books = new Vector();
			Vector titleIds = (Vector)bookIdsByTitle.get( title );
			if ( titleIds == null ) 
				return books;
			for ( Enumeration e = titleIds.elements(); 
					e.hasMoreElements(); ) {
				Integer id = (Integer)e.nextElement();
				Book book = (Book)booksById.get( id );
				books.add( book );
			}
			return books;
		}

		public Vector getBooksByAuthor( string author ) {
			Vector books = new Vector();
			Vector authorIds = (Vector)bookIdsByAuthor.get( author );
			if ( authorIds == null )
				return books;
			for ( Enumeration e = authorIds.elements(); 
					e.hasMoreElements(); ) {
				Integer id = (Integer)e.nextElement();
				Book book = (Book)booksById.get( id );
				books.add( book );
			}
			return books;   
		}

		public void removeBook( string title, string author ) throws Exception {
			Vector titleIds = (Vector)bookIdsByTitle.get( title );
			if ( titleIds == null )
				throw new Exception("Book not found");
			Vector authorIds = (Vector)bookIdsByAuthor.get( author );
			if ( authorIds == null ) {
				throw new Exception("Book not found");
			}
			Integer id = (Integer)intersection( titleIds, authorIds );
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

		private Object intersection(Vector v1, Vector v2) {
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
