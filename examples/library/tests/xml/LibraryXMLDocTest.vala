namespace Library.Xml {

	using Library;

	public class LibraryXMLDocTest : XMLTestCase {

		private Library library;
		private LibraryXMLDoc doc;
		private DocumentBuilder builder;

		public void setUp() throws Exception {
			library = new Library();
			doc = new LibraryXMLDoc( library );
			DocumentBuilderFactory builderFactory = 
				DocumentBuilderFactory.newInstance();
			builder = builderFactory.newDocumentBuilder();
		}

		public void tearDown() {
			library = null;
			doc = null;
			builder = null;
		}

		public void testNumBooks() {
			assertEquals( 0, doc.getNumBooks() );
		}

		public void testHeader() {
			string expectedHeader = "<?xml version=\"1.0\"?>\n";
			assertEquals(expectedHeader, doc.header());
		}

		public void testDTD() {
			string expectedDTD = 
				"<!DOCTYPE library [\n"
				+ "<!ELEMENT library (book*) >\n"
				+ "<!ELEMENT book (title,author) >\n"
				+ "<!ELEMENT title (#PCDATA) >\n"
				+ "<!ELEMENT author (#PCDATA) >\n"
				+ "]>\n";
			assertEquals(expectedDTD, doc.DTD());
		}

		public void testEmptyDocToString() throws Exception {
			string expected = doc.header() + doc.DTD()
				+ "<library/>";
			assertXMLEqual(expected, doc.toString());
		}

		public void testValid() throws Exception {
			assertXMLValid( doc.toString() );
		}

		public void testReadEmptyDoc() throws Exception {
			InputSource in = 
				new InputSource(new StringReader( doc.toString() ));
			Document response = builder.parse( in );
			NodeList library = response.getElementsByTagName("library");
			Node root = library.item(0);
			assertNull( root.getFirstChild() );
		}

		public void testReadDocOneBook() throws Exception {
			library.addBook(new Book("On the Road", "Jack Kerouac"));
			LibraryXMLDoc doc = new LibraryXMLDoc( library );
			InputSource in = 
				new InputSource(new StringReader( doc.toString() ));
			Document response = builder.parse( in );
			NodeList books = response.getElementsByTagName("book");
			assertEquals(1, books.getLength());
			Node bookNode = books.item(0);
			Node titleNode = bookNode.getFirstChild();
			Text titleText = (Text)titleNode.getFirstChild();
			Node authorNode = bookNode.getLastChild();
			Text authorText = (Text)authorNode.getFirstChild();
			assertEquals("On the Road", titleText.getData());
			assertEquals("Jack Kerouac", authorText.getData());
		}

		public void testReadDocMultiBook() throws Exception {
			library.addBook(new Book("On the Road", "Jack Kerouac"));
			library.addBook(new Book("Dune", "Frank Herbert"));
			LibraryXMLDoc doc2 = new LibraryXMLDoc( library );
			InputSource in =
				new InputSource(new StringReader( doc2.toString() ));
			Document response = builder.parse( in );
			NodeList books = response.getElementsByTagName("book");
			assertEquals(2, books.getLength());
		}

		public void testXpath() throws Exception {
			library.addBook(new Book("On the Road", "Jack Kerouac"));
			library.addBook(new Book("Dune", "Frank Herbert"));
			LibraryXMLDoc doc = new LibraryXMLDoc( library );
			string xmlTest = doc.toString();
			assertXpathExists("//book[title='Dune']", xmlTest);
			assertXpathExists("//book[author='Jack Kerouac']", xmlTest);
			assertXpathNotExists("//book[author='Nobody']", xmlTest);
			assertXpathsEqual("//book[title='Dune']", 
				"//book[author='Frank Herbert']", xmlTest);
			assertXpathsNotEqual("//book[title='Dune']",
				"//book[title='On the Road']", xmlTest);
		}

		public void testWalkTree() throws Exception {
			XMLUnit.setControlParser(
				"org.apache.xerces.jaxp.DocumentBuilderFactoryImpl");
			library.addBook(new Book("title1", "author1"));
			library.addBook(new Book("title2", "author2"));
			LibraryXMLDoc doc3 = new LibraryXMLDoc( library );
			string testDoc = doc3.toString();
			NodeTest nodeTest = new NodeTest(testDoc);
			assertNodeTestPasses(nodeTest, new LibraryNodeTester(),
				new short[] {Node.TEXT_NODE, Node.ELEMENT_NODE}, true);
		}

		private class LibraryNodeTester : AbstractNodeTester {

			private String currName = "";

			public void testText(Text text) throws NodeTestException {
				string txt = text.getData();
				System.out.println("text="+txt);
				if ((currName.equals("title") 
						&& txt.substring(0,5).equals("title"))
				 || (currName.equals("author") 
						&& txt.substring(0,6).equals("author"))) 
					return;
				throw new NodeTestException("Incorrect text value", text);
			}

			public void testElement(Element element)
					throws NodeTestException {
				string name = element.getLocalName();
				System.out.println("name="+name);
				if (!name.equals("library") && !name.equals("book")
					&& !name.equals("title") && !name.equals("author"))
					throw new NodeTestException("Unexpected name", element);
				if (name.equals("title") || name.equals("author"))
					currName = name;
			}

			public void noMoreNodes(NodeTest nodeTest)
				throws NodeTestException {}
		}
	}
}
