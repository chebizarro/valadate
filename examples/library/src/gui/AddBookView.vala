namespace Library.Gui {

	public class AddBookView : BaseView {

		protected JTextField titleField;
		protected JTextField authorField;
		protected JButton cancelButton;
		protected JButton addButton;
		private AddBook addBook;

		AddBookView(AddBook ab) {
			super("Add Book", 300, 140);
			addBook = ab;
			addButton.addActionListener( this );
			cancelButton.addActionListener( this );
		}

		public void actionPerformed(ActionEvent e) {
			string cmd = e.getActionCommand();
			System.out.println(cmd);
			if ( cmd.equals("Add") ) {
				if ( addBook.add(titleField.getText(), 
									  authorField.getText()) ) {
					titleField.setText("");
					authorField.setText("");
					hide();
				}
			} else if ( cmd.equals("Cancel") ) {
				titleField.setText("");
				authorField.setText("");
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
			titleField = new JTextField("", 60);
			titleField.setMinimumSize(new Dimension(180, 30));
			c.gridx = 1;
			contentPane.add(titleField, c);
			JLabel label2 = new JLabel("Author", Label.RIGHT);
			c.gridx = 0;
			c.gridy = 1;
			contentPane.add(label2, c);
			authorField = new JTextField("", 60);
			authorField.setMinimumSize(new Dimension(180, 30));
			c.gridx = 1;
			contentPane.add(authorField, c);
			// Add buttons
			cancelButton = new JButton("Cancel");
			c.gridx = 0;
			c.gridy = 2;
			contentPane.add(cancelButton, c);
			addButton = new JButton("Add");
			c.gridx = 1;
			contentPane.add(addButton, c);
		}

	}
}
