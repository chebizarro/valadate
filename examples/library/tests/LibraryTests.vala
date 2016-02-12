namespace Library {

	using Library.Gui;
	using Library.Xml;

	public class LibraryTests : TestSuite {

		public static Test suite() {
			TestSuite suite = new TestSuite();
			// Library and Book tests
			suite.addTest(new TestSuite(BookTest.class));
			suite.addTest(new TestSuite(LibraryTest.class));
			suite.addTest(new TestSuite(LibraryDBTest.class));
			suite.addTest(LibraryPerfTest.suite());
			// GUI application tests
			suite.addTest(new TestSuite(BookViewTest.class));
			suite.addTest(new TestSuite(AddBookViewTest.class));
			suite.addTest(new TestSuite(AddBookTest.class));
			suite.addTest(new TestSuite(FindBookByTitleViewTest.class));
			suite.addTest(new TestSuite(FindBookByTitleTest.class));
			suite.addTest(new TestSuite(LibraryFrameViewTest.class));
			suite.addTest(new TestSuite(LibraryFrameTest.class));
			// XML and document tests
			suite.addTest(new TestSuite(LibraryXMLDocTest.class));
			suite.addTest(new TestSuite(XMLElementTest.class));
			return suite;
		}

	}
}
