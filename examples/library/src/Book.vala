namespace Library {

	public class Book : Object {

		public string title {get; private set;}
		public string author {get; private set;}

		public Book(string title, string? author = null) {
			this.title = title;
			this.author = author;
		}

	}
}
