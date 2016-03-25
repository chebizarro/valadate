namespace Valadate.Framework {

	public class TestGtk : TestCase {

		public void test_gtk_window() {

			var testwindow = Gtk.test_create_simple_window("TestWindow", "Valadate Test");
			
			//testwindow.show();
			
			assert(testwindow is Gtk.Widget);

		}
	
	
	}

}
