namespace Library.Gui {

	public abstract class BaseViewTestCase extends TestCase {

		public abstract BaseView getBaseView();

		public void testNotVisible() {
			BaseView view = getBaseView();
			assertFalse( view.isVisible() );
		}

		public void testShow() {
			BaseView view = getBaseView();
			view.show();
			assertTrue( view.isVisible() );
		}

		public void testClose() {
			BaseView view = getBaseView();
			view.show();
			WindowEvent e = new WindowEvent(view, 
				WindowEvent.WINDOW_CLOSING);
			Toolkit.getDefaultToolkit().getSystemEventQueue().postEvent(e);
			try {
				Thread.currentThread().sleep(300);
			} catch(Exception x) {}
			assertFalse( view.isVisible() );
		}
	}
}
