namespace Library.Gui {

	using Library;

	public class LibraryFrameTest extends TestCase {

		private Library library;
		private LibraryFrame frame;

		public void setUp() {
			library = new Library();
			frame = new LibraryFrame(library);
		}

		public void tearDown() {
			frame = null;
		}

		public void testDefaultState() {
			assertTrue( frame.addBook != null );
			assertTrue( frame.findBookByTitle != null );
		}

	}

}
