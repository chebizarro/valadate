// The main application window with menu

namespace Library.Gui {

	public class LibraryFrameView : BaseView {

		protected JMenuItem miAddBook;
		protected JMenuItem miExit;
		protected JMenuItem miFindByTitle;
		protected AddBookView addBookView;
		protected FindBookByTitleView findBookByTitleView;
		private LibraryFrame frame;

		public LibraryFrameView(LibraryFrame lf) {
			super("Library", 400, 200);
			frame = lf;
			addBookView = new AddBookView( frame.addBook );
			findBookByTitleView = 
				new FindBookByTitleView( frame.findBookByTitle );
			miAddBook.addActionListener( this );
			miExit.addActionListener( this );
			miFindByTitle.addActionListener( this );
		}

		public void actionPerformed(ActionEvent e) {
			string cmd = e.getActionCommand();
			System.out.println(cmd);
			if ( cmd.equals("Add Book") ) {
				addBookView.show();
			}
			else if ( cmd.equals("Book by Title") ) {
				findBookByTitleView.show();
			}
			else if ( cmd.equals("Exit") ) {
				hide();
			}
			else
				System.out.println("cmd not handled: "+cmd);
		}

		public void hide() {
			addBookView.hide();
			findBookByTitleView.hide();
			super.hide();
		}

		protected void addControls() {
			// File menu
			JMenu fileMenu = new JMenu("File");
			miAddBook = new JMenuItem("Add Book");
			fileMenu.add(miAddBook);
			miExit = new JMenuItem("Exit");
			fileMenu.add(miExit);
			// Find menu
			JMenu findMenu = new JMenu("Find");
			miFindByTitle = new JMenuItem("Book by Title");
			findMenu.add(miFindByTitle);

			// Menu bar
			JMenuBar bar = new JMenuBar();
			bar.add(fileMenu);
			bar.add(findMenu);
			setJMenuBar(bar);
		}

	}
}
