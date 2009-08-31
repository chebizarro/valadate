using GLib;
using Introspection;

errordomain GirError {
	NOT_A_GIR,
	CANNOT_READ,
	COMPILATION_FAILED,
	TYPE_NOT_LOADED,
}

[NoArrayLength]
[CCode(array_length=false, array_null_terminated=true)]
string[] files = null;

[NoArrayLength]
[CCode(array_length=false, array_null_terminated=true)]
string[] libs = null;
int nextlib = 0;

[NoArrayLength]
[CCode(array_length=false, array_null_terminated=true)]
string[] typelib_path = null;

bool verbose = false;

SList<Typelib> typelibs = null;

const OptionEntry[] options = {
// long-name, short-name, flags, argtype, ref var, description, metavar
	{"library", 'l', 0, OptionArg.FILENAME_ARRAY, ref libs,
		"Shared library corresponding to the GIR files", "LIB"},
	{"typelib-dir", 'd', 0, OptionArg.FILENAME_ARRAY, ref typelib_path,
		"Additional search directory for typelib files", "DIR"},
	{"verbose", 'v', 0, OptionArg.NONE, ref verbose,
		"Report classes and methods found", ""},
	{"", 0, 0, OptionArg.FILENAME_ARRAY, ref files,
		"GIR files of test modules to run", "GIR-OR-TYPELIB..."},
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
	var args = new string[]{"g-ir-compiler"};
	if(libs != null & libs[nextlib] != null) {
		args += "-l";
		args += libs[nextlib];
	}
	args += "-o";
	args += typelib_file;
	args += gir_file;
	int status;
	Process.spawn_sync(
			null, // working directory - inherit
			args, // arguments
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
}

bool is_fixture(ObjectInfo oi)
{
	var n_ifs = oi.get_n_interfaces();
	for(int i = 0; i < n_ifs; ++i) {
		InterfaceInfo ii = oi.get_interface(i);
		if(verbose)
			stdout.printf("Found interface %s.%s...\n",
					ii.get_namespace(), ii.get_name());
		if(ii.get_namespace() == "Valadate" &&
				ii.get_name() == "Fixture") {
			return true;
		}
	}
	return false;
}

void gather_test_cases(TestSuite ns_suite, ObjectInfo type_info)
	throws GirError
{
	var n_methods = type_info.get_n_methods();
	var suite = new TestSuite(type_info.get_name());
	ns_suite.add_suite(suite);

	for(int i = 0; i < n_methods; ++i) {
		var method = type_info.get_method(i);
		if(verbose)
			stdout.printf("    Method %s: flags=%i\n",
					method.get_name(),
					method.get_flags());
		if((method.get_flags() & FunctionInfoFlags.IS_METHOD) != 0 &&
				method.get_name().has_prefix("test_")) {
			if(verbose)
				stdout.printf("        is test\n");
			suite.add(new TestInfo(type_info,
						method).make_case());
		}
	}
}

void gather_tests()
	throws GirError
{
	var r = Repository.get_default();
	var namespaces = r.get_loaded_namespaces();
	var root = TestSuite.get_root();
	// - search GIRepository for fixtures
	foreach(string ns in namespaces) {
		TestSuite ns_suite = null;
		var n_infos = r.get_n_infos(ns);
		for(int i = 0; i < n_infos; ++i) {
			var info = r.get_info(ns, i);
			if(verbose)
				stdout.printf("Found info %s of type %i\n",
						info.get_name(), info.get_type());
			if(info.get_type() != InfoType.OBJECT)
				break;
			if(!is_fixture((ObjectInfo)info))
				break;
			if(ns_suite == null)
				ns_suite = new TestSuite(ns);
			gather_test_cases(ns_suite, (ObjectInfo)info);
		}
		if(ns_suite != null)
			root.add_suite(ns_suite);
	}
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

		for(int i = typelib_path.length - 1; i >= 0; --i) {
			Repository.prepend_search_path(typelib_path[i]);
		}

		foreach(weak string file in files) {
			process_file(file);
		}

		gather_tests();
	} catch(Error e) {
		stderr.printf("%s\n", e.message);
		return 1;
	}
	return 0;
}
