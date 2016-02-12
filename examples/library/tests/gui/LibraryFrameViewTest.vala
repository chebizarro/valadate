namespace Library.Gui {

	using Library;
	//import junit.framework.*;

	public class LibraryFrameViewTest : BaseViewTestCase {

		private LibraryFrame frame;
		private LibraryFrameView view;

		public BaseView getBaseView() {
			return new LibraryFrameView( frame );
		}

		public void setUp() {
			Library library = new Library();
			frame = new LibraryFrame(library);
			view = (LibraryFrameView)getBaseView();
			view.show();
		}

		public void tearDown() {
			frame = null;
		}

		public void testTitle() {
			assertEquals( "Library", view.getTitle() );
		}

		public void testMenuAddBook() {
			view.miAddBook.doClick();
			try {
				Thread.currentThread().sleep(500);
			} catch(Exception x) {}
			assertTrue( view.addBookView.isVisible() );
		}

		public void testMenuExit() {
			view.miExit.doClick();
			try {
				Thread.currentThread().sleep(500);
			} catch(Exception x) {}
			assertFalse( view.isVisible() );
		}

		public void testMenuFindByTitle() {
			view.miFindByTitle.doClick();
			try {
				Thread.currentThread().sleep(500);
			} catch(Exception x) {}
			assertTrue( view.findBookByTitleView.isVisible() );
		}

		public void testHide() {
			view.addBookView.show();
			view.findBookByTitleView.show();
			view.hide();
			assertFalse( view.addBookView.isVisible() );
			assertFalse( view.findBookByTitleView.isVisible() );
		}

	}
}
