// BaseView
// Custom subclass of JFrame used for Library GUI windows

namespace Library.Gui {

	public abstract class BaseView : JFrame, ActionListener {

		BaseView(string title, int width, int height) {
			super(title);
			addControls();
			setSize(width, height);
		}

		public abstract void actionPerformed(ActionEvent e);
		protected abstract void addControls();
	}
}
