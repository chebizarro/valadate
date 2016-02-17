namespace Library {


	public class LibraryPerfTest : TestCase {

		private Library library;
		private double maxTime = 100; // milliseconds

		public static Test suite() {
			TestSuite testSuite = new TestSuite(LibraryPerfTest.class);
			PerfTestSetup testSetup = new PerfTestSetup(testSuite);
			return testSetup;
		}

		public void setUp() throws Exception {
			library = PerfTestSetup.getLibrary();
		}

		public void tearDown() {
			library = null;
		}

		public void testPerfGetBooksByTitle() {
			long startTime = System.currentTimeMillis();
			Vector books = library.get_books_by_title( "book99999" );
			long endTime = System.currentTimeMillis();
			long time = endTime-startTime;
			System.out.println("time="+time);
			Assert.is_true(time < maxTime );
			Assert.equals(1, books.size() );
			Book book = (Book)books.elementAt(0);
			Assert.equals("book99999", book.getTitle() );
		}

		public void testPerfGetBooksByAuthor() {
			long startTime = System.currentTimeMillis();
			Vector books = library.getBooksByAuthor( "author99999" );
			long endTime = System.currentTimeMillis();
			long time = endTime-startTime;
			System.out.println("time="+time);
			Assert.is_true(time < maxTime );
			Assert.equals(1, books.size() );
			Book book = (Book)books.elementAt(0);
			Assert.equals("book99999", book.getTitle() );
		}

		public void testPerfGetBookByTitleAuthor() {
			long startTime = System.currentTimeMillis();
			Book book = library.getBook( "book99999", "author99999" );
			long endTime = System.currentTimeMillis();
			long time = endTime-startTime;
			System.out.println("time="+time);
			Assert.is_true(time < maxTime );
			assertNotNull( book );
		}

	}

}
