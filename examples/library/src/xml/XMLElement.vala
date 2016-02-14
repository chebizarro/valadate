namespace Library.Xml {

	using Gee;

	public class XMLElement {

		private string name;
		private string content;
		private ArrayList<XMLElement> children;

		public XMLElement(string n, string c = "") {
			name = n;
			content = c;
			children = new ArrayList<XMLElement>();
		}

		public void add_child(XMLElement child) {
			children.add(child);
		}

		public string to_string() {
			if ( content.length == 0 && children.size == 0 )
				return "<"+name+"/>";
			else {
				string result = "<"+name+">"+content;
				
				foreach (XMLElement e in children)
					result += e.to_string();

				result += "</"+name+">";
				return result;
			}
		}

	}
}
