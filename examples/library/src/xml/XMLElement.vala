namespace Library.Xml {

	public class XMLElement {

		private string name;
		private string content;
		private ArrayList<XMLElement> children;

		XMLElement(string n, string c = "") {
			name = n;
			content = c;
			children = new ArrayList<XMLElement>();
		}

		public void addChild(XMLElement child) {
			children.addElement( child );
		}

		public string toString() {
			if ( content.length() == 0 && children.size() == 0 )
				return "<"+name+"/>";
			else {
				string result = "<"+name+">"+content;
				for (Enumeration e = children.elements();
					  e.hasMoreElements(); ) {
					XMLElement element = (XMLElement)e.nextElement();
					result += element.toString();
				}
				result += "</"+name+">";
				return result;
			}
		}

	}
}
