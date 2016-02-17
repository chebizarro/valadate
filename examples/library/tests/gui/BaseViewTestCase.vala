namespace Library.Gui {

	using Valadate;

	public abstract class BaseViewTestCase : Valadate.TestCase {

		public abstract BaseView getBaseView();

		public void testNotVisible() {
			BaseView view = getBaseView();
			Assert.is_false(view.visible);
		}

		public void testShow() {
			BaseView view = getBaseView();
			view.show();
			Assert.is_true(view.visible);
		}

		public void testClose() {
			BaseView view = getBaseView();
			view.show();
			/*
			WindowEvent e = new WindowEvent(view, 
				WindowEvent.WINDOW_CLOSING);
			Toolkit.getDefaultToolkit().getSystemEventQueue().postEvent(e);
			try {
				Thread.currentThread().sleep(300);
			} catch(Exception x) {}
			Assert.is_false(view.visible );
			*/
		}
	}
}
