using GLib;
using Introspection;

namespace ValadateRunner {
    class GirReader: Object, Reader {
        private SList<Typelib> typelibs = null; // If we dropped them, gobject-introspection would unload them.
        private SList<SuiteInfo> suites = null; // Stash away the SuiteInfo objects, because the test system does not hold them

        public bool process_file(string file) throws Error
        {
            string tlfile;
            // If we have .gir, compile it.
            if(file.has_suffix(".gir")) {
                tlfile = compile_typelib(file);
            } else {
                tlfile = file;
            }
            if(!tlfile.has_suffix(".typelib"))
                return false;

            // Create the typelib and load it...
            var r = Repository.get_default();
            var tl = Typelib.new_from_mapped_file(new MappedFile(tlfile, false));
            // - r.load_typelib with the thing we've got
            r.load_typelib(tl, 0);
            typelibs.prepend((owned)tl);
            return true;
        }

        public void gather_tests() throws Error
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
                        continue;
                    if(!is_fixture((ObjectInfo)info))
                        continue;
                    if(ns_suite == null)
                        ns_suite = new TestSuite(ns);
                    gather_test_cases(ns_suite, (ObjectInfo)info);
                }
                if(ns_suite != null)
                    root.add_suite(ns_suite);
            }
        }

        private string compile_typelib(string gir_file) throws SpawnError, RunnerError
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
                throw new RunnerError.CANNOT_READ(
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
                throw new RunnerError.COMPILATION_FAILED(
                        "g-ir-compiler -o %s %s failed with status %i",
                        typelib_file, gir_file, status);
            return typelib_file;
        }

        private bool is_fixture(ObjectInfo oi)
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

        private void gather_test_cases(TestSuite ns_suite, ObjectInfo type_info) throws RunnerError, InvokeError
        {
            if(verbose)
                stdout.printf("    searching for tests in %s\n",
                        type_info.get_name());
            var suite = new TestSuite(type_info.get_name());
            ns_suite.add_suite(suite);
            var sinfo = new SuiteInfo(type_info);
            sinfo.create_tests(suite);
            suites.prepend((owned)sinfo);
            if(verbose)
                stdout.printf("    search complete in %s\n",
                        type_info.get_name());
        }

    }
}
