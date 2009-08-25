using GLib;
using Introspection;

[NoArrayLength]
[CCode(array_length=false, array_null_terminated=true)]
string[] files = null;

const OptionEntry[] options = {
// long-name, short-name, flags, argtype, ref var, description, metavar
	{"", 0, 0, OptionArg.FILENAME_ARRAY, ref files, "GIR files of test modules to run", "GIR"},
	{null, 0, 0, 0, null, null, null}
};

void process_file(string file) throws Error // XXX: Which errors it may throw?
{
	Repository r = Repository.get_default();
	// - Call the g-ir-compiler and read it's output
	// - r.load_typelib with the thing we've got
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
	} catch(OptionError e) {
		message("Error: %s", e.message);
		return 1;
	}

	if(files.length == 0) {
		message("Error: No files specified.");
		return 1;
	}

	try {
		foreach(string file in files) {
			process_file(file);
		}
	} catch(Error e) {
		message("Error: %s", e.message);
		return 1;
	}
	return 0;
}
