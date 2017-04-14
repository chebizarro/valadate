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

namespace Valadate.XmlTags {
	
	public const string XML_DECL ="<?xml version=\"1.0\" encoding=\"UTF-8\"?>";

	public const string ERROR_TAG = "error";
	public const string FAILURE_TAG = "failure";
	public const string VDX_TAG = "info";//"vdx:info";
	public const string VDX_TIMER = "timer";//"vdx:timer";
	public const string VDX_NS = ""; //"xmlns:vdx=\"https://www.valadate.org/vdx\"";
	public const string SYSTEM_OUT_TAG = "system-out";
	public const string SYSTEM_ERR_TAG = "system-err";

	private const string regex_string =
		"""([<]{1}([a-z:]*){1} message="([\w\d =,-.:_&!\/;\n()]*)" """+
		"""type="[A-Z_()a-z]+"( xmlns:vdx="https:\/\/www\.valadate\.org\/vdx"){0,1}"""+
		""">[\w\d =.:,_&!\/;\n()]*<\/[a-z:]*>)+""";
		
	private const string regex_err_string =
		"""(\*{2}\n([A-Z]*):([\S]*) ([\S ]*)\n)""";

	public const string TESTSUITES_XML =
		"""<testsuites disabled="" errors="" failures="" name="" """ +
		"""tests="" time=""></testsuites>""";

	public const string TESTSUITE_XML =
		"""<testsuite disabled="" errors="" failures="" hostname="" id="" """ +
		"""name="" package="" skipped="" tests="" time="" timestamp="" >"""+
		"""<properties/></testsuite>""";
		
	public const string TESTCASE_XML =
		"""<testcase assertions="" classname="" name="" status="" time="" />""";

	public const string SKIPPED_XML = "<skipped/>";
	
	public const string MESSAGE_XML = "<%s message=\"%s\" type=\"%s\">%s</%s>\n";

	public const string ROOT_XML = "<root %s>%s</root>";



	public const string ROOT_START = "<root " + VDX_NS + ">";
	public const string ROOT_END = "</root>";

	public const string TESTCASE_START =
		"<testcase assertions=\"\" classname=\"%s\" name=\"%s\" status=\"\" time=\"\">";
	public const string TESTCASE_END = "</testcase>";



}
