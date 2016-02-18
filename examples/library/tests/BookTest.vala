using Valadate;

namespace Library {

	public class BookTest : Framework.TestCase {

		[Test (name="construct_book")]
		public void testConstructBook() {
			Book book = new Book("");
			Assert.not_null(book);
		}

		[Test (name="book_title")]
		public void testBookTitle() {
			Book book = new Book( "Solaris" );
			Assert.equals("Solaris", book.title);
		}

		[Test (name="book_author")]
		public void testBookAuthor() {
			Book book = new Book("Cosmos", "Carl Sagan");
			Assert.equals("Carl Sagan", book.author, "wrong author");
		}

		/*
		public void testGetFields() {
			Book book = new Book( "test", "test" );
			Field fields[] = book.getClass().getDeclaredFields();
			for ( int i = 0; i < fields.length; i++ ) {
				fields[i].setAccessible( true );
				try {
					string value = (string)fields[i].get( book );
					Assert.equals( "test", value );
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
						Assert.equals( "test", value );
					} catch (Exception e) {
						fail( e.getMessage() );
					}
				}
			}
		}*/
		
	}

}
