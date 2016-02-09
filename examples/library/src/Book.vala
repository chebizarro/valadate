namespace Library {

	public class Book {

		Book(String title) { this.title = title; }
		public Book(String title, string author) {
			this.title = title;
			this.author = author;
		}

		public string getTitle() { return title; }
		public string getAuthor() { return author; }

		private string title = "";
		private string author = "";

	}
}
