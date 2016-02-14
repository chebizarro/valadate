using Library;

namespace Library.Xml {

	public class LibraryXMLDoc {

		private Library library;
		private XMLElement rootElement;

		public int num_books {
			get {
				return library.get_num_books();
			}
		}

		public LibraryXMLDoc(Library lib) {
			library = lib;
			rootElement = new XMLElement( "library" );
			foreach (Book book in library) {
				XMLElement bookElement = new XMLElement( "book" );
				XMLElement titleElement = 
					new XMLElement("title", book.title);
				bookElement.add_child(titleElement );
				XMLElement authorElement = 
					new XMLElement( "author", book.author);
				bookElement.add_child(authorElement);
				rootElement.add_child(bookElement);
			}
		}

		public static string header() {
			return "<?xml version=\"1.0\"?>\n";
		}

		public static string DTD() {
			return "<!DOCTYPE library [\n"
				+ "<!ELEMENT library (book*) >\n"
				+ "<!ELEMENT book (title,author) >\n"
				+ "<!ELEMENT title (#PCDATA) >\n"
				+ "<!ELEMENT author (#PCDATA) >\n"
				+ "]>\n";
		}

		public string to_string() {
			string result = header()+DTD();
			result += rootElement.to_string();
			return result;
		}
	}
}
