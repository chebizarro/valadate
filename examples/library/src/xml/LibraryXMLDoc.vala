namespace Library.Xml {

	using Library;

	public class LibraryXMLDoc {

		private Library library;
		private XMLElement rootElement;

		LibraryXMLDoc(Library lib) {
			library = lib;
			rootElement = new XMLElement( "library" );
			for (Enumeration e = library.elements();
				  e.hasMoreElements(); ) {
				Book book = (Book)e.nextElement();
				XMLElement bookElement = new XMLElement( "book" );
				XMLElement titleElement = 
					new XMLElement( "title", book.getTitle() );
				bookElement.addChild( titleElement );
				XMLElement authorElement = 
					new XMLElement( "author", book.getAuthor() );
				bookElement.addChild( authorElement );
				rootElement.addChild( bookElement );
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

		public string toString() {
			string result = header()+DTD();
			result += rootElement.toString();
			return result;
		}

		public int getNumBooks() {
			return library.getNumBooks();
		}
	}
}
