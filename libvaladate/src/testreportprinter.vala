/*
 * Valadate -- 
 * Copyright 2017 Chris Daley <bizarro@localhost.localdomain>
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
 * 
 */

using Valadate.XmlTags;

namespace Valadate {
	
	public abstract class TestReportPrinter {
		
		public XmlFile xml {get;set;}

		public TestConfig config {get;set;}
		
		public TestReportPrinter(TestConfig config) throws Error {
			this.config = config;
			xml = new XmlFile.from_string(XML_DECL + TESTSUITES_XML);
		}
		
		private Xml.Node* testsuite;
		private int testcount = -1;
		
		public virtual void print(TestReport report) {
			Xml.Node* root = xml.eval("//testsuites")[0];
			Xml.Node* newnode = report.xml.eval("//testsuite | //testcase")[0];
			Xml.Node* node = newnode;

			if(report.test is TestCase || report.test is TestSuite) {
				if(testsuite == null) {
					testcount = report.test.count;
					testsuite = root->add_child(node);
				} else {
					testsuite = testsuite->add_child(node);
					testcount--;
				}
			} else if(report.test is TestAdapter) {
				testsuite->add_child(node);
				testcount--;
			}
			
			var logname = Environment.get_variable("TEST_LOGS");
			if(logname == null)
				logname = "test";
			if(logname != null && testcount == 0)
				root->doc->save_format_file(logname.strip() + ".xml", 1);
		}
		
	}
}
