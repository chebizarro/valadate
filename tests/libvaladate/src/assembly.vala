namespace Valadate.Tests {

	public class ConcreteAssembly : Assembly {
		
		public class ConcreteAssembly(File binary) {
			base(binary);
		}
		
		public override Assembly clone() {
			return new ConcreteAssembly(binary) as Assembly;
		}
		
	}

	public static void new_assembly() {
		
		var oldenv = Environment.get_variable("G_TEST_SRCDIR");
		var builddir = Environment.get_variable("G_TEST_BUILDDIR");
		
		var newenv = File.new_for_path(Path.build_filename(
			oldenv, "..", "data"));
		
		var binary = File.new_for_path(Path.build_filename(
			builddir, "..", "data", ".libs", "testexe-0"));
		
		Environment.set_variable("G_TEST_SRCDIR", newenv.get_path(), true);
		
		var assembly = new ConcreteAssembly(binary);
		
		assert(assembly is ConcreteAssembly);
	}

	public static void new_assembly_fail() {
		
		GLib.Test.trap_subprocess("/assembly/newfail/subprocess", 0,0);
		GLib.Test.trap_assert_failed();
	}

	public static void new_assembly_fail_subprocess() {
		
		var oldenv = Environment.get_variable("G_TEST_SRCDIR");
		var builddir = Environment.get_variable("G_TEST_BUILDDIR");
		
		var newenv = File.new_for_path(Path.build_filename(
			oldenv, "..", "data"));
		
		var binary = File.new_for_path(Path.build_filename(
			builddir, "..", "data", "testexe-0.gir"));
		
		Environment.set_variable("G_TEST_SRCDIR", newenv.get_path(), true);
		try {
			var assembly = new ConcreteAssembly(binary);
			assert(assembly is ConcreteAssembly);
		} catch(Error e) {
			assert_not_reached();
		}
	}

	public static void run_assembly() {
		
		var oldenv = Environment.get_variable("G_TEST_SRCDIR");
		var builddir = Environment.get_variable("G_TEST_BUILDDIR");
		
		var newenv = File.new_for_path(Path.build_filename(
			oldenv, "..", "data"));
		
		var binary = File.new_for_path(Path.build_filename(
			builddir, "..", "data", "helloworld"));
		
		Environment.set_variable("G_TEST_SRCDIR", newenv.get_path(), true);
		
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
		var oldenv = Environment.get_variable("G_TEST_SRCDIR");
		var builddir = Environment.get_variable("G_TEST_BUILDDIR");
		
		var newenv = File.new_for_path(Path.build_filename(
			oldenv, "..", "data"));
		
		var binary = File.new_for_path(Path.build_filename(
			builddir, "..", "data", "helloworld"));
		
		Environment.set_variable("G_TEST_SRCDIR", newenv.get_path(), true);
		
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
