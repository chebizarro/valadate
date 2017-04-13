/*
 * Valadate - Unit testing library for GObject-based libraries.
 * Copyright (C) 2016  Chris Daley <chebizarro@gmail.com>
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

	public class XmlTestReportPrinter : TestReportPrinter {
		
		private List<TestCase> testcases = new List<TestCase>();
		
		public XmlTestReportPrinter(TestConfig config) {
			base(config);
		}
		
		private Xml.Node* testsuite;
		
		public override void print(TestReport report) {
			Xml.Node* root = xml.eval("/");
			Xml.Node* newnode = report.xml.eval("/");
			var node = newnode->copy_list();

			if(report.test is TestCase || report.test is TestSuite) {
				if(testsuite == null) {
					root->add_child(node);
					testsuite = node;
				} else {
					testsuite->add_child(node);
				}
			} else if(report.test is TestAdapter) {
				
				testsuite->add_child(node);
			}
			
			root->doc->save_file("testoutput.xml");
			
		}
	}
}
