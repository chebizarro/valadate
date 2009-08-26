using GLib;
using Introspection;

errordomain GirError {
	NOT_A_GIR,
	CANNOT_READ,
	COMPILATION_FAILED,
}

[NoArrayLength]
[CCode(array_length=false, array_null_terminated=true)]
string[] files = null;

SList<Typelib> typelibs = null;

const OptionEntry[] options = {
// long-name, short-name, flags, argtype, ref var, description, metavar
	{"", 0, 0, OptionArg.FILENAME_ARRAY, ref files, "GIR files of test modules to run", "GIR-OR-TYPELIB..."},
	{null, 0, 0, 0, null, null, null}
};

string compile_typelib(string gir_file) throws SpawnError, GirError
{
	string typelib_file = gir_file.substring(0, gir_file.length - 3);
	typelib_file += "typelib";

	// Stat both files, check whether typelib is newer
	// FIXME: When stat becomes available in GLib namespace, use it for
	// Windooze compatibility.
	Posix.Stat gir_stat;
	Posix.Stat typelib_stat;
	if(Posix.stat(gir_file, out gir_stat) != 0)
		// FIXME: Should throw FileError from errno, but I can't.
		throw new GirError.CANNOT_READ(
				"Cannot read %s: %s", gir_file,
				Posix.strerror(Posix.errno));
	if(Posix.stat(typelib_file, out typelib_stat) == 0) {
		// Both files stated, so compare the timestamps...
		if(typelib_stat.st_mtime > gir_stat.st_mtime)
			// typelib is up-to-date
			return typelib_file;
	}

	// Execute g-ir-compiler to (re)generate the typelib
	int status;
	Process.spawn_sync(
			null, // working directory - inherit
			new string[] { "g-ir-compiler", "-o", typelib_file,
					gir_file }, // arguments
			null, // environment - inherit
			SpawnFlags.SEARCH_PATH, // flags - command in path
			null, // child setup func
			null, // pass through stdout
			null, // pass through stderr
			out status); // exit status
	if(status != 0)
		throw new GirError.COMPILATION_FAILED(
				"g-ir-compiler -o %s %s failed with status %i",
				typelib_file, gir_file, status);
	return typelib_file;
}

void process_file(owned string file)
	throws SpawnError, GirError, FileError, RepositoryError
{
	// If we have .gir, compile it.
	if(file.has_suffix(".gir")) {
		file = compile_typelib(file);
	}
	if(!file.has_suffix(".typelib"))
		throw new GirError.NOT_A_GIR(
				"%s is neither .gir nor .typelib",
				file);

	// Create the typelib and load it...
	var r = Repository.get_default();
	var tl = Typelib.new_from_mapped_file(new MappedFile(file, false));
	// - r.load_typelib with the thing we've got
	r.load_typelib(tl, 0);
	typelibs.prepend((owned)tl);
	// XXX: This is not per-typelib, since it's done on the repository
	// anyway...
	// - search it for fixtures
	// - search fixtures for test methods
	// - create the cases
	// - run the cases
}

int main(string[] args)
{
	var op = new OptionContext("");
	try {
		op.add_main_entries(options, null);
		op.set_help_enabled(true);
		op.parse(ref args);

		if(files.length == 0) {
			stderr.printf("Error: No files specified.\n");
			return 1;
		}

		foreach(string file in files) {
			process_file(file);
		}
	} catch(Error e) {
		stderr.printf("%s\n", e.message);
		return 1;
	}
	return 0;
}
