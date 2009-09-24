/*
 * Valadate - Unit testing library for GObject-based libraries.
 * Copyright (C) 2009  Jan Hudec <bulb@ucw.cz>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published
 * by the Free Software Foundation, either version 3 of the License, or (at
 * your option) any later version.
 *
 * This program is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
 * or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Lesser General Public
 * License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

using GLib;

namespace ValadateRunner {
        interface Reader {
            public abstract bool process_file(string file) throws Error;
            public abstract void gather_tests() throws Error;
        }

    errordomain RunnerError {
        UNRECOGNIZED_FILE,
        CANNOT_READ,
        COMPILATION_FAILED,
        TYPE_NOT_LOADED,
        NOT_FOUND,
        VAPI_ERROR,
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
    string[] path = null;

    bool verbose = false;

    SList<Reader> readers = null;

    const OptionEntry[] options = {
    // long-name, short-name, flags, argtype, ref var, description, metavar
        {"library", 'L', 0, OptionArg.FILENAME_ARRAY, ref libs,
            "Shared library corresponding to the test file", "LIB"},
        {"dir", 'd', 0, OptionArg.FILENAME_ARRAY, ref path,
            "Additional search directory for vapi and/or typelib files", "DIR"},
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

            readers.prepend(new GirReader());
            readers.prepend(new VapiReader());

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
}
