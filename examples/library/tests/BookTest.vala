namespace Library {

	public class BookTest : TestCase {

		public void testConstructBook() {
			Book book = new Book("");
			assertNotNull( book );
		}

		public void testBookTitle() {
			Book book = new Book( "Solaris" );
			assertEquals( "Solaris", book.getTitle() );
		}

		public void testBookAuthor() {
			Book book = new Book( "Cosmos", "Carl Sagan" );
			assertEquals( "wrong author", "Carl Sagan", book.getAuthor() );
		}

		public void testGetFields() {
			Book book = new Book( "test", "test" );
			Field fields[] = book.getClass().getDeclaredFields();
			for ( int i = 0; i < fields.length; i++ ) {
				fields[i].setAccessible( true );
				try {
					String value = (String)fields[i].get( book );
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
						String value = (String)methods[i].invoke( book, null );
						assertEquals( "test", value );
					} catch (Exception e) {
						fail( e.getMessage() );
					}
				}
			}
		}
	}

}
