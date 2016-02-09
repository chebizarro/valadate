namespace Library.Gui {

	public class FindBookByTitleView : BaseView {

		protected JTextField titleField;
		protected JLabel msgField;
		protected JButton cancelButton;
		protected JButton findButton;
		private FindBookByTitle findBook;

		FindBookByTitleView(FindBookByTitle fb) {
			super("Find Book By Title", 300, 130);
			findBook = fb;
			findButton.addActionListener( this );
			cancelButton.addActionListener( this );
		}

		public void actionPerformed(ActionEvent e) {
			string cmd = e.getActionCommand();
			System.out.println(cmd);
			if ( cmd.equals("Find") ) {
				string title = titleField.getText();
				findBook.find( title );
				if ( findBook.getFoundBook() == null ) {
					msgField.setText("Book not found: "+title);
				} else {
					msgField.setText("");
				}
			}
			else if ( cmd.equals("Cancel") ) {
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
			contentPane.add(titleField); 
			msgField = new JLabel("", JLabel.CENTER);
			msgField.setMinimumSize(new Dimension(200, 30));
			c.gridx = 0;
			c.gridy = 1;
			c.gridwidth = 2;
			contentPane.add(msgField, c);
			// Add buttons
			cancelButton = new JButton("Cancel");
			c.gridx = 0;
			c.gridy = 2;
			c.gridwidth = 1;
			contentPane.add(cancelButton, c);
			findButton = new JButton("Find");
			c.gridx = 1;
			contentPane.add(findButton, c);
		}

	}
}
