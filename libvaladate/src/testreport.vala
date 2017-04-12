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
namespace Valadate { 

	public class TestReport {

		private const string testsuitexml =
		"""<testsuite disabled="" errors="" failures="" hostname="" id="" """ +
		"""name="" package="" skipped="" tests="" time="" timestamp="">""" +
		"""<properties><property name="" value=""/></properties>""" +
		"""</testsuite>""";
		private const string testcasexml =
		"""<testcase assertions="" classname="" name="" status="" time=""/>""";
		public Test test {get;set;}
		
		public XmlFile xml {get;set;}
		
		private Xml.Doc* doc;
		
		private Xml.Node* root;
		
		public TestReport(Test test) throws Error {
			this.test = test;

			if(test is TestSuite || test is TestCase)
				new_testsuite();
			else if (test is TestAdapter)
				new_testcase();

			root->set_prop("name",test.label);
			xml = new XmlFile.from_doc(doc);
			xml.register_ns("vdx", "https://www.valadate.org/vdx");
		}
		
		private void new_testsuite() {
			doc = Xml.Parser.read_memory(testsuitexml, testsuitexml.length);
			root = doc->get_root_element();;
			root->set_prop("tests", count_tests(test).to_string());
		}

		private void new_testcase() {
			doc = Xml.Parser.read_memory(testcasexml, testcasexml.length);
			root = doc->get_root_element();;
			root->set_prop("classname",((TestAdapter)test).parent.name);
			root->set_prop("status",test.status.to_string().substring(21));
		}

		private int count_tests(Test test) {
			var testcount = 0;
			if(test is TestSuite)
				foreach(var subtest in test)
					testcount += count_tests(subtest);
			else
				testcount += test.count;
			return testcount;
		}

		~TestReport() {
			delete doc;
		}

		public void add_text(string text) {
			if(test is TestAdapter) {
				Xml.Node* child = new Xml.Node.pi("system-out", text);
				root->add_child(child);
			}
		}
		
		public void add_xml(string xml) {
			var newDoc = Xml.Parser.read_memory(xml, xml.length);
			if(newDoc == null)
				return;
				
			var node = newDoc->get_root_element();
			root->add_child(node->copy_list());
		}
		
		public void update_status() {
			if(test is TestAdapter) {
				root->set_prop("status",test.status.to_string().substring(21));
				root->set_prop("time",test.time.to_string());
			}
		}
		
	}
}
