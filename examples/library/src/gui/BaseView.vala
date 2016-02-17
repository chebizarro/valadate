// BaseView
// Custom subclass of JFrame used for Library GUI windows

namespace Library.Gui {

	public abstract class BaseView : Gtk.Window {

		//string title;

		public BaseView(string title, int width, int height) {
			this.title = title;
			//addControls();
			set_default_size(width, height);
		}

		//public abstract void actionPerformed(ActionEvent e);
		//protected abstract void addControls();
	}
}
