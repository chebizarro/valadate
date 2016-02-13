using Valadate;

namespace Library {

	public class BookTest : Valadate.TestCase {

		[Test (name="construct_book")]
		public void testConstructBook() {
			Book book = new Book("");
			assert(book != null);
		}

		[Test (name="book_title")]
		public void testBookTitle() {
			Book book = new Book( "Solaris" );
			assert("Solaris" == book.title);
		}

		[Test (name="book_author")]
		public void testBookAuthor() {
			Book book = new Book("Cosmos", "Carl Sagan");
			//assertEquals( "wrong author", "Carl Sagan", book.author );
			assert("Carl Sagan" == book.author);
		}

		/*
		public void testGetFields() {
			Book book = new Book( "test", "test" );
			Field fields[] = book.getClass().getDeclaredFields();
			for ( int i = 0; i < fields.length; i++ ) {
				fields[i].setAccessible( true );
				try {
					string value = (string)fields[i].get( book );
					assertEquals( "test", value );
				} catch (Exception e) {
					fail( e.getMessage() );
				}
			}
		}

		public void testInvokeMethods() {
			Book book = new Book( "test", "test" );
			Method[] methods = book.getClass().getDeclaredMethods();
			for ( int i = 0; i < methods.length; i++ ) {
				if ( methods[i].getName().startsWith("get") ) {
					methods[i].setAccessible( true );
					try {
						string value = (string)methods[i].invoke( book, null );
						assertEquals( "test", value );
					} catch (Exception e) {
						fail( e.getMessage() );
					}
				}
			}
		}*/
		
	}

}
