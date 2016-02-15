namespace Valadate.Tests.Utils {

	static void main (string[] args) {

		GLib.Test.init (ref args);
		GLib.TestSuite.get_root().add_suite(new TempDirTest().suite);
		GLib.TestSuite.get_root().add_suite(new TestSignalWaiter().suite);
		GLib.TestSuite.get_root().add_suite(new TestAsync().suite);
		GLib.Test.run ();

	}
}
