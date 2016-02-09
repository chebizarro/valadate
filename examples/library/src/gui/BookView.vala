namespace Library.Gui {

	using Library;

	public class BookView : JFrame {

		JLabel titleField;
		JLabel authorField;
		private Book book;

		BookView( Book b ) {
			super("Book");
			this.book = b;
			addControls();
			this.setDefaultCloseOperation( DISPOSE_ON_CLOSE );
		}

		private void addControls() {
			Container contentPane = this.getContentPane();
			contentPane.setLayout(new GridBagLayout());
			GridBagConstraints c = new GridBagConstraints();

			// Add labels and text fields
			JLabel label1 = new JLabel("Title", Label.RIGHT);
			c.insets = new Insets(2, 2, 2, 2);
			c.gridx = 0;
			c.gridy = 0;
			contentPane.add(label1, c);
			titleField = new JLabel( book.getTitle() );
			titleField.setMinimumSize(new Dimension(180, 30));
			c.gridx = 1;
			c.gridwidth = 3;
			c.fill = GridBagConstraints.HORIZONTAL;
			contentPane.add(titleField, c); 
			JLabel label2 = new JLabel("Author", Label.RIGHT);
			c.gridx = 0;
			c.gridy = 1;
			c.gridwidth = 1;
			contentPane.add(label2, c);
			authorField = new JLabel( book.getAuthor() );
			c.gridx = 1;
			c.gridwidth = 3;
			contentPane.add(authorField, c);

			setSize(300, 100);
		}

	}
}
