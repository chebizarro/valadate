namespace Valadate.Tests {

	public static void new_assembly() {
		
		var assembly = new ConcreteAssembly(testbinary);
		
		assert(assembly is ConcreteAssembly);
	}

	public static void new_assembly_fail() {
		
		GLib.Test.trap_subprocess("/assembly/newfail/subprocess", 0,0);
		GLib.Test.trap_assert_failed();
	}

	public static void new_assembly_fail_subprocess() {
		
		var builddir = Environment.get_variable("G_TEST_BUILDDIR");
		
		var binary = File.new_for_path(Path.build_filename(
			builddir, "..", "data", "testexe-0.gir"));
		
		try {
			var assembly = new ConcreteAssembly(binary);
			assert(assembly is ConcreteAssembly);
		} catch(Error e) {
			assert_not_reached();
		}
	}

	public static void run_assembly() {
		
		var builddir = Environment.get_variable("G_TEST_BUILDDIR");
		
		var binary = File.new_for_path(Path.build_filename(
			builddir, "..", "data", "helloworld"));
		
		var assembly = new ConcreteAssembly(binary);
		
		assembly.run();
		
		var reader = new DataInputStream (assembly.stdout);
		
		string str = reader.read_line ();
		string res = null;

		while (str != null) {
			res = str;
			str = reader.read_line ();
		}
		assert(res == "Hello world!");
	}

	public static void run_fail() {
		GLib.Test.trap_subprocess("/assembly/runfail/subprocess", 0,0);
		GLib.Test.trap_assert_failed();
	}

	public static void run_fail_subprocess() {
		var builddir = Environment.get_variable("G_TEST_BUILDDIR");
		var binary = File.new_for_path(Path.build_filename(
			builddir, "..", "data", "helloworld"));
		
		var assembly = new ConcreteAssembly(binary);
		
		assembly.run("-hasnoparams");
		
		var reader = new DataInputStream (assembly.stdout);
		
		string str = reader.read_line ();
		string res = null;

		while (str != null) {
			res = str;
			str = reader.read_line ();
		}
		assert(res == "Hello world!");

	}
}
