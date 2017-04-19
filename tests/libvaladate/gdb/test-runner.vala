namespace Valadate {

	private class Gdb : Assembly {
		
		public Gdb() throws Error {
			var gdb = Environment.find_program_in_path("libtool");
			if(gdb == null)
				throw new FileError.EXIST(
					"libtool cannot be found in the environment's path, is it properly installed?");
			
			base(File.new_for_path(gdb));
		}
		
		public override Assembly clone() {
			return new Gdb();
		}
		
		public override Assembly run(string? cmd = null, Cancellable? cancellable = null) {
			return base.run(" --mode=execute gdb " + cmd ?? "", cancellable);
		}
		
	}
	

	public class GdbTestCase : TestCase {

		public void test_run_all_tests() {

			var gdb = new Gdb();
			var builddir = Environment.get_variable("G_TEST_BUILDDIR");
			var srcdir = Environment.get_variable("G_TEST_SRCDIR");
			var cmd = "-nw -nx ";
			cmd += "--ex=%s ".printf(Shell.quote("add-auto-load-safe-path="+builddir));
			cmd += "--ex=%s ".printf(Shell.quote(
				"set env LD_LIBRARY_PATH %s".printf(Config.VALADATE_LIB_DIR)));
			cmd += " --ex=%s ".printf(Shell.quote(
				"file %s".printf(Path.build_path(builddir, "gdb-tests-0"))));
			/*			cmd += " --eval-command=%s ".printf(Shell.quote(
				"python testlibdir=%s".printf(Path.build_path(builddir, "lib-for-tests"))));

			cmd += " --eval-command=%s ".printf(Shell.quote(
				"python testscript=%s".printf("test-object.py")));
			cmd += " --eval-command=%s ".printf(Shell.quote(
				"python exec(open(%s).read())".printf(Path.build_path(builddir, "lib-for-tests", "catcher.py"))));
			*/
/*
			"--ex", "add-auto-load-safe-path %s" % (OPTIONS.builddir,),
			"--ex", "set env LD_LIBRARY_PATH %s" % os.path.join(OPTIONS.objdir, "libvaladate"),
			"--ex", "file %s" % (os.path.join(OPTIONS.builddir, "gdb-tests-0"),),
			"--eval-command", "python testlibdir=%r" % (testlibdir,),
			"--eval-command", "python testscript=%r" % (self.test_path,),
			"--eval-command", "python exec(open(%r).read())" % os.path.join(testlibdir, "catcher.py")]
*/

			var file = File.new_for_path(srcdir + "/tests");

			var enumerator = file.enumerate_children (
				"standard::*",
				FileQueryInfoFlags.NOFOLLOW_SYMLINKS, 
				null);

			FileInfo info = null;
			var space = "";
			while ((info = enumerator.next_file ()) != null) {
				if (info.get_file_type () != FileType.DIRECTORY) {
					
					stdout.printf ("%s%s\n", space, info.get_name ());
					stdout.printf ("%s %s\n", space, info.get_file_type ().to_string ());
					stdout.printf ("%s %s\n", space, info.get_is_symlink ().to_string ());
					stdout.printf ("%s %s\n", space, info.get_is_hidden ().to_string ());
					stdout.printf ("%s %s\n", space, info.get_is_backup ().to_string ());
					stdout.printf ("%s %"+int64.FORMAT+"\n", space, info.get_size ());
				}
			}

			
			gdb.run(cmd + " --ex q");
			
			var bis = new BufferedInputStream(gdb.stderr);
			bis.fill(-1);
			debug("%s\n", (string)bis.peek_buffer());
			
		}

	}

}
