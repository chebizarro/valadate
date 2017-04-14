/*
 * Valadate - Unit testing library for GObject-based libraries.
 * Copyright (C) 2017  Chris Daley <chebizarro@gmail.com>
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.

 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.

 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301  USA
 *
 * Authors:
 * 	Chris Daley <chebizarro@gmail.com>
 */
 
using Valadate.XmlTags;
 
namespace Valadate { 

	public class TestReport {

		public Test test {get;set;}
		
		public XmlFile xml {get;set;}
		
		//private Xml.Doc* doc;
		
		//private Xml.Node* root;
		
		public TestReport(Test test) throws Error {
			this.test = test;

			if(test is TestSuite || test is TestCase)
				new_testsuite();
			else if (test is TestAdapter)
				new_testcase();

		}

		
		private void new_testsuite() {
			var decl = XML_DECL + ROOT_XML.printf(VDX_NS, TESTSUITE_XML);
			var doc = Xml.Parser.read_memory(decl, decl.length);
			var root = doc->get_root_element()->children;
			root->set_prop("tests", test.count.to_string());
			root->set_prop("name",test.label);
			xml = new XmlFile.from_doc(doc);
			
			if(test.parent != null && test.parent.name != "/")
				return;
			
			var props = root->children;
			
			foreach(var key in Environment.list_variables()) {
				Xml.Node* node = new Xml.Node(null, "property");
				node->set_prop("name", key);
				node->set_prop("value", Markup.escape_text(Environment.get_variable(key)));
				props->add_child(node);
			}
		}

		private void new_testcase() {
			var decl = XML_DECL + ROOT_XML.printf(VDX_NS, TESTCASE_XML);
			var doc = Xml.Parser.read_memory(decl, decl.length);
			var root = doc->get_root_element()->children;
			root->set_prop("classname",((TestAdapter)test).parent.name);
			root->set_prop("status",test.status.to_string().substring(21));
			root->set_prop("name",test.label);
			xml = new XmlFile.from_doc(doc);
			
		}

		public void add_text(string text, string tag) {
			if(test is TestAdapter) {
				Xml.Node* child = new Xml.Node(null, tag);
				child->set_content(Markup.escape_text(text));
				Xml.Node* root = xml.eval("//testcase")[0];
				root->add_child(child);
			}
		}
		
		/*
		public void add_xml(string xml) {
			var decl = XML_DECL + ROOT_XML.printf(VDX_NS, xml);
			var newDoc = Xml.Parser.read_memory(decl, decl.length);
			if(newDoc == null)
				return;
				
			Xml.Node* node = newDoc->get_root_element()->children;
			//node->unset_ns_prop(node->ns, "xmlns:vdx");
			//node->ns_def = null; //root->parent->ns_def;
			//node->set_ns(root->ns);
			root->add_child(node);
		}*/
		
		public void update_status() {
			if(test is TestAdapter) {
				Xml.Node* root = xml.eval("//testcase")[0];
				root->set_prop("status",test.status.to_string().substring(21));
				root->set_prop("time",test.time.to_string());
			}
		}
		
	}
}
