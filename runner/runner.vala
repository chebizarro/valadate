using GLib;
using ValadateRunner;

namespace ValadateRunner {
	interface Reader {
		public abstract bool process_file(string file) throws Error;
		public abstract void gather_tests() throws Error;
	}
} // FIXME: Extend the namespace over whole file!

errordomain RunnerError {
	UNRECOGNIZED_FILE,
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

SList<Reader> readers = null;

const OptionEntry[] options = {
// long-name, short-name, flags, argtype, ref var, description, metavar
	{"library", 'L', 0, OptionArg.FILENAME_ARRAY, ref libs,
		"Shared library corresponding to the test file", "LIB"},
	{"typelib-dir", 'd', 0, OptionArg.FILENAME_ARRAY, ref typelib_path,
		"Additional search directory for typelib files", "DIR"},
	{"verbose-search", 'V', 0, OptionArg.NONE, ref verbose,
		"Report classes and methods found", ""},
	{"file", 'f', 0, OptionArg.FILENAME_ARRAY, ref files,
		"gir or typelib file of test modules to run", "FILE"},
	{null, 0, 0, 0, null, null, null}
};


void process_file(string file) throws Error
{
    weak SList<Reader> reader;
    for(reader = readers; reader != null; reader = reader.next) {
	if(reader.data.process_file(file))
	    return;
    }
    throw new RunnerError.UNRECOGNIZED_FILE("File %s is not of any known type.", file);
}

void gather_tests()
	throws Error
{
    weak SList<Reader> reader;
    for(reader = readers; reader != null; reader = reader.next) {
	reader.data.gather_tests();
    }
}

int main(string[] args)
{
	readers.prepend(new GirReader());

	var op = new OptionContext("");
	try {
		op.add_main_entries(options, null);
		op.set_help_enabled(true);
		op.set_description(
			"Test Options:\n" +
			"  -l                             List test cases available in a test executable\n" +
			"  -seed=RANDOMSEED               Provide a random seed to reproduce test\n" +
			"                                 runs using random numbers\n" +
			"  --verbose                      Run tests verbosely\n" +
			"  -q, --quiet                    Run tests quietly\n" +
			"  -p TESTPATH                    execute all tests matching TESTPATH\n" +
			"  -m {perf|slow|thorough|quick}  Execute tests according modes\n" +
			"  --debug-log                    debug test logging output\n" +
			"  -k, --keep-going               gtester-specific argument\n" +
			"  --GTestLogFD=N                 gtester-specific argument\n" +
			"  --GTestSkipCount=N             gtester-specific argument\n");
		op.set_ignore_unknown_options(true);
		op.parse(ref args);

		if(files.length == 0) {
			stderr.printf("Error: No files specified.\n");
			return 1;
		}

		for(int i = typelib_path.length - 1; i >= 0; --i) {
			Introspection.Repository.prepend_search_path(typelib_path[i]);
		}

		foreach(weak string file in files) {
			process_file(file);
		}

		gather_tests();

		Test.init(ref args);
		Test.run();
	} catch(Error e) {
		stderr.printf("%s\n", e.message);
		return 1;
	}
	return 0;
}
