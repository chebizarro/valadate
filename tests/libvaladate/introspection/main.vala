namespace Valadate.Introspection.Tests {

	static void main (string[] args) {

		GLib.Test.init (ref args);
		GLib.TestSuite.get_root().add_suite(new IntrospectionTest().suite);
		GLib.TestSuite.get_root().add_suite(new ModuleTest().suite);
		GLib.Test.run ();

	}
}
