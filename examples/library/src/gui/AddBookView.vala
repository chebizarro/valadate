namespace Library.Gui {

    [GtkTemplate (ui = "/org/gtk/library/addbookview.ui")]
	public class AddBookView : BaseView {

        [GtkChild]
		public Gtk.Entry title_field;
        [GtkChild]
		public Gtk.Entry author_field;
        [GtkChild]
		public Gtk.Button cancel_button;
        [GtkChild]
		public Gtk.Button add_button;

		private AddBook addBook;

		//[GtkCallback]
		/*
		public override void response(int response_id) {
			
		}*/

		public AddBookView(AddBook ab) {
			base("Add Book", 300, 140);
			addBook = ab;
			//add_button.addActionListener( this );
			//cancel_button.addActionListener( this );
		}

		/*
		public void actionPerformed(ActionEvent e) {
			string cmd = e.getActionCommand();
			System.out.println(cmd);
			if ( cmd.equals("Add") ) {
				if ( addBook.add(title_field.get_text(), 
									  author_field.get_text()) ) {
					title_field.set_text("");
					author_field.set_text("");
					hide();
				}
			} else if ( cmd.equals("Cancel") ) {
				title_field.set_text("");
				author_field.set_text("");
				hide();
			}
			else
				System.out.println("cmd not handled: "+cmd);
		}

		protected void addControls() {
			Container contentPane = this.getContentPane();
			contentPane.setLayout(new GridBagLayout());
			GridBagConstraints c = new GridBagConstraints();

			// Add labels and text fields
			JLabel label1 = new JLabel("Title", Label.RIGHT);
			c.insets = new Insets(2, 2, 2, 2);
			c.gridx = 0;
			c.gridy = 0;
			contentPane.add(label1, c);
			title_field = new Gtk.Entry("", 60);
			title_field.setMinimumSize(new Dimension(180, 30));
			c.gridx = 1;
			contentPane.add(title_field, c);
			JLabel label2 = new JLabel("Author", Label.RIGHT);
			c.gridx = 0;
			c.gridy = 1;
			contentPane.add(label2, c);
			author_field = new Gtk.Entry("", 60);
			author_field.setMinimumSize(new Dimension(180, 30));
			c.gridx = 1;
			contentPane.add(author_field, c);
			// Add buttons
			cancel_button = new Gtk.Button("Cancel");
			c.gridx = 0;
			c.gridy = 2;
			contentPane.add(cancel_button, c);
			add_button = new Gtk.Button("Add");
			c.gridx = 1;
			contentPane.add(add_button, c);
		}
		*/
	}
}
