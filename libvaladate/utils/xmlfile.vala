/*
 * Valadate - Unit testing library for GObject-based libraries.
 * Copyright 2016 Chris Daley <chebizarro@gmail.com>
 * 
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
 * MA 02110-1301, USA.
 * 
 */

namespace Valadate {

	public errordomain XmlFileError {
		ERROR
	}

	internal class XmlSearchResults {
		
		private Xml.XPath.Object* result;

		public int size {
			get {
				if(result == null || result->type != Xml.XPath.ObjectType.NODESET || result->nodesetval == null)
					return 0;
				return result->nodesetval->length();
			}
		}

		public Xml.Node* get(int i)
			requires(size > 0)
			requires(i < size)
			requires(i >= 0)
		{
			return result->nodesetval->item (i);
		}
		
		
		public XmlSearchResults(Xml.XPath.Object* result) {
			this.result = result;
		}

		~XmlSearchResults() {
			if(result != null) delete result;
		}

	}

	internal class XmlFile {
		
		private Xml.Doc* document;
		private Xml.XPath.Context context;
		
		public XmlFile(string path) throws Error {
			document = Xml.Parser.parse_file(path);

			if (document == null)
				throw new XmlFileError.ERROR(
					"There was an error parsing the file at %s", path);

			context = new Xml.XPath.Context (document);
		}

		public void register_ns(string prefix, string ns) {
			context.register_ns(prefix, ns);
		}

		public XmlSearchResults eval(string expression) {
			return new XmlSearchResults(context.eval_expression (expression));
		}
		
		~XmlFile() {
			delete document;
		}
		
		
	}


}
