namespace Valadate.Tests {

	public const string MESSAGE_XML = "<%s message=\"%s\" type=\"%s\">%s</%s>\n";
	public const string SYSTEM_ERR_TAG = "system-err";

	public static void test_report_new() {
		
		var test = new MockTestCase();

		var report = new TestReport(test, false);
		assert(report is TestReport);
		assert(report.xml is XmlFile);
	}

	public static void test_report_new_is_testcase() {
		
		var test = new MockTestCase();
		var report = new TestReport(test, false);

		var root = (Xml.Node*)report.xml.eval("//testsuite")[0];
		
		assert(root->name == "testsuite");
	}

	public static void test_report_add_text() {
		
		var test = new MockTestCase();
		var report = new TestReport(test, false);
		var mess = "testcase:43 this is a new message";
		var str = MESSAGE_XML.printf(SYSTEM_ERR_TAG, mess, "INFO", mess, SYSTEM_ERR_TAG);

		report.add_text(mess, SYSTEM_ERR_TAG);

		var root = report.xml.eval("//testsuite/system-err");
		assert(root.size == 1);
	}


}
