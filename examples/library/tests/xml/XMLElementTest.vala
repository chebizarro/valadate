namespace Library.Xml {

	//import org.custommonkey.xmlunit.*;

	public class XMLElementTest : XMLTestCase {

		public void testEmptyElement() throws Exception {
			XMLElement element = new XMLElement("test");
			string expected = "<test></test>";
			assertXMLEqual(expected, element.toString());
		}

		public void testEmptyElementIdentical() throws Exception {
			XMLElement element = new XMLElement("test");
			string expected = "<test/>";
			Diff diff = new Diff(expected, element.toString());
			assertXMLIdentical(diff, true);
		}

		public void testContent() throws Exception {
			XMLElement element = new XMLElement("test", "content");
			string expected = "<test>content</test>";
			assertXMLEqual(expected, element.toString());
		}

		public void testAddChild() throws Exception {
			XMLElement element = new XMLElement("test");
			XMLElement child = new XMLElement("child", "content");
			element.addChild( child );
			string expected = "<test><child>content</child></test>";
			assertXMLEqual(expected, element.toString());
		}

		public void testAddChildren() throws Exception {
			XMLElement element = new XMLElement("test");
			XMLElement child = new XMLElement("child", "content");
			XMLElement child2 = new XMLElement("child2", "content2");
			element.addChild( child );
			element.addChild( child2 );
			string expected = 
				"<test><child>content</child><child2>content2</child2></test>";
			assertXMLEqual(expected, element.toString());
		}

	}
}
