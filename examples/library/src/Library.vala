public errordomain Exception {
	DUPLICATE,
	NOT_FOUND
}

namespace Library {

	using Gee;

	public class Library {

		private HashMap<int, Book>  booksById;
		private HashMap<string, ArrayList<int>> bookIdsByAuthor;
		private HashMap<string, ArrayList<int>> bookIdsByTitle;
		private static int nextBookId; 

		public Library() {
			booksById = new HashMap<int, Book> ();
			bookIdsByAuthor = new HashMap<string, ArrayList<int>> ();
			bookIdsByTitle = new HashMap<string, ArrayList<int>> ();
			nextBookId = 0;
		}

		public void add_book( Book book ) throws Exception {
			ArrayList<int> titleIds = bookIdsByTitle.get(book.title);
			ArrayList<int> authorIds = bookIdsByAuthor.get(book.author);
			if (titleIds != null && authorIds != null) {
				if (intersection(titleIds, authorIds) != null )
					throw new Exception.DUPLICATE("Duplicate Book");
			}
			if ( titleIds == null )
				titleIds = new ArrayList<int>();
			if ( authorIds == null )
				authorIds = new ArrayList<int>();
			nextBookId++;
			int id = nextBookId;
			titleIds.add(id);
			bookIdsByTitle.set(book.title, titleIds);
			authorIds.add(id);
			bookIdsByAuthor.set(book.author, authorIds);
			booksById.set(id, book);
		}

		public Book? get_book(string title, string author) {
			ArrayList<int> titleIds = bookIdsByTitle.get(title);
			if ( titleIds == null )
				return null;
			ArrayList<int> authorIds = bookIdsByAuthor.get(author);
			if ( authorIds == null )
				return null;
			int? id = intersection( titleIds, authorIds );
			if ( id == null )
				return null;
			return booksById.get(id);
		}

		public ArrayList<Book> get_books_by_title( string title ) {
			ArrayList<Book> books = new ArrayList<Book>();
			ArrayList<int> titleIds = bookIdsByTitle.get( title );
			if (titleIds == null) 
				return books;
			foreach (int bookid in titleIds)
				books.add(booksById.get(bookid));
			return books;
		}

		public ArrayList<Book> get_books_by_author( string author ) {
			ArrayList<Book> books = new ArrayList<Book>();
			ArrayList<int> authorIds = bookIdsByAuthor.get(author);
			if (authorIds == null) 
				return books;
			foreach (int bookid in authorIds)
				books.add(booksById.get(bookid));
			return books;
		}

		public void remove_book(string title, string author) throws Exception {
			ArrayList<int> titleIds = bookIdsByTitle.get( title );
			if (titleIds == null)
				throw new Exception.NOT_FOUND("Book title: %s not found", title);
			ArrayList<int> authorIds = bookIdsByAuthor.get(author);
			if ( authorIds == null )
				throw new Exception.NOT_FOUND("Book by author: %s not found", author);

			int id = intersection(titleIds, authorIds);
			if (titleIds.size == 1)
				bookIdsByTitle.unset(title);
			else {
				titleIds.remove(id);
				bookIdsByTitle.set(title, titleIds);
			}
			if (authorIds.size == 1)
				bookIdsByAuthor.unset(author);
			else {	
				authorIds.remove(id);
				bookIdsByAuthor.set(author, authorIds);
			}
			if ( booksById.unset(id) == false )
				throw new Exception.NOT_FOUND("Book %s not found", title);
		}

		public Iterator<Book> iterator() {
			return booksById.values.iterator();
		}

		public int get_num_books() {
			return booksById.size;
		}

		public void empty() {
			booksById.clear();
			bookIdsByTitle.clear();
			bookIdsByAuthor.clear();
			nextBookId = 0;
		}

		private int? intersection(ArrayList<int> v1, ArrayList<int> v2) {
			Iterator<int> iter = v1.iterator();
			while ( iter.next() )
			{
				int obj = iter.get();
				if ( v2.contains( obj ) )
					return obj;
			}
			return null;
		}
	}
}
