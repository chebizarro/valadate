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

[ CCode ( gir_version = "1.0", gir_namespace = "Valadate") ]
namespace Valadate.Utils {
    /**
     * Class to provide a temporary test directory to unit tests.
     *
     * To use, instantiate this class either inside your test method or as
     * a member of your test fixture. It will automatically create a test
     * directory upon instantiation and remove it again upon destruction.
     *
     * With the current GLib.Test-based runner, the destruction will not run
     * if the test fails, so the directory is not deleted if the test fails.
     * (it is not currently printed anywhere though).
     */
     
    public class TempDir : Object {
        // SECTION: static data
        private static string orig_dir = Environment.get_current_dir();
        private static string tmp_dir = Environment.get_tmp_dir();

        /**
         * Returns name of the original working directory of the test
         * process.
         *
         * Or rather, name of working directory at time the type was
         * initialized.
         */
        public class string get_orig_dir_name() {
            return orig_dir;
        }

        /**
         * Get name of system-wide temporary directory.
         *
         * This is just a cached value of Environment.get_tmp_dir.
         */
        public class string get_tmp_dir_name() {
            return tmp_dir;
        }

        // SECTION: Members and properties
        private File _dir = make_tmp_dir();

        /**
         * The test directory.
         *
         * A GLib.File object representing the test directory.
         */
        public File dir { get { return _dir; } }

        /**
         * The original working directory.
         *
         * The working directory in which the tests were started (again,
         * obtained when the type is initialized, so it might get changed
         * before that).
         */
        public File src_dir { owned get { return File.new_for_path(orig_dir); } }

        // SECTION: Utility methods
        /**
         * File object for file or directory inside the test directory.
         */
        public File file(string path) {
            return dir.resolve_relative_path(path);
        }

        /**
         * Read whole content of specified file in test directory.
         *
         * Note, that it's a string, so it's nul-terminated. If the file
         * contains nul bytes, the content will be truncated there as far as
         * any string operations are concerned.
         *
         * If the file does not exist or cannot be read, aborts with fatal
         * error, failing the test it is in.
         *
         * @param path Path to be read, relative to dir.
         * @return Content of the file at path.
         */
        public string contents(string path) {
            string str;
            try {
                DataInputStream dins = new DataInputStream(file(path).read());
                StringBuilder builder = new StringBuilder();
                for (;;) {
                    string? line = dins.read_line_utf8(null);
                    if (line == null)
                        break;
                    
                    builder.append(line);
                    builder.append("\n");
                }
                
                str = builder.str;
            } catch(Error e) {
                error("Failed to read content from \"%s\": %s", path,
                        e.message);
            }
            
            return str;
        }

        // SECTION: Initialization
        /**
         * Write content to a specified file in test directory.
         *
         * Replaces the file if it already exists. If the file cannot be
         * written, aborts with fatal error, failing the test it is in.
         *
         * @param path Path to be written, relative to dir.
         * @param content Data to write to path.
         */
        public TempDir store(string path, string content) {
            File f = file(path);
            try {
                try {
                    f.get_parent().make_directory_with_parents(null);
                } catch(IOError.EXISTS e) {}
                f.replace_contents(content.data, null, false,
                        FileCreateFlags.REPLACE_DESTINATION, null, null);
            } catch(Error e) {
                error("Failed to write to \"%s\": %s", path, e.message);
            }
            return this;
        }

        /**
         * Copy file or directory from original working dir to test dir.
         *
         * Copies recursively the tree at src_path to path. The content of
         * src_path is placed directly into path (i.e. no subdirectory is
         * created if path exists unlike cp command). If the file or tree
         * cannot be copied, aborts with fatal error, failing the test it is
         * in.
         *
         * @param path Destination path, relative to dir.
         * @param src_path Source path, relative to src_dir (or absolute).
         */
        public TempDir copy(string path, string src_path) {
            File dst = file(path);
            try {
                try {
                    dst.get_parent().make_directory_with_parents(null);
                } catch(IOError.EXISTS e) { /* that's ok */ }
                File src = src_dir.resolve_relative_path(src_path);
                do_copy(dst, src);
            } catch(Error e) {
                error("Failed to copy \"%s\" to \"%s\": %s", src_path, path,
                        e.message);
            }
            return this;
        }

        /**
         * Execute shell code in context of the test dir.
         *
         * Executes code, via {{{/bin/sh}}}, in a specified subdirectory of
         * the test directory. If shell cannot be executed or the script
         * exits with nonzero status, aborts with fatal error, failing the
         * test.
         *
         * @param path Working directory for the script, relative to dir. It
         *        is created if it did not exist.
         * @param code Shell code that will be piped to standard input of
         *        {{{/bin/sh}}}.
         */
        public TempDir shell(string path, string code) {
            File test_dir = file(path);
            try {
                test_dir.make_directory_with_parents(null);
            } catch(Error e) { /* that's ok */ }
            try {
                Environment.set_variable("testdir", test_dir.get_path(), true);
                Environment.set_variable("srcdir", get_orig_dir_name(), true);
                Pid pid;
                int in_handle;
                Process.spawn_async_with_pipes(
                        test_dir.get_path(), // working directory
                        new string[] { "/bin/sh", "-" }, // command-line: XXX: configurable shell (configure-time)
                        null, // default environment
                        SpawnFlags.DO_NOT_REAP_CHILD, // flags
                        null, // child setup func
                        out pid, // pid
                        out in_handle, // stdin file handle
                        null, // stdout file handle
                        null); // stderr file hande
                IOChannel in_ch = new IOChannel.unix_new(in_handle);
                IOStatus status = in_ch.write_chars((char[])code, null);
                if(status != IOStatus.NORMAL)
                    error("Sending data to shell failed, status: %i",
                            status);
                in_ch.shutdown(true);
                int exitcode;
                Posix.waitpid((Posix.pid_t)pid, out exitcode, 0);
                if(exitcode != 0)
                    error("Shell script failed with status: %i", exitcode);
            } catch(Error e) {
                error("Error while trying to run shell snippet in %s: %s",
                        path, e.message);
            }
            return this;
        }

        // SECTION: Shutdown and internal
        /**
         * Deletes a file or directory, recursively.
         *
         * This is used to clean up the test directory after the test
         * completes.
         */
        public static void delete_recursive(File file) throws Error {
            try {
                FileEnumerator i = file.enumerate_children(
                        "standard::name",
                        FileQueryInfoFlags.NOFOLLOW_SYMLINKS, null);
                FileInfo? e;
                while((e = i.next_file(null)) != null) {
                    delete_recursive(file.get_child(e.get_name()));
                }
                i.close(null);
            } catch(IOError.NOT_DIRECTORY e) { /* that's ok */ }
            file.delete(null);
        }

        ~TempDir() {
            try {
                delete_recursive(dir);
            } catch(Error e) {
                critical("Could not remove temp dir %s: %s", dir.get_path(),
                        e.message);
            }
        }

        private static string get_random_name() {
            return "%s%cvaladate-%08X".printf(
                    tmp_dir,
                    Path.DIR_SEPARATOR,
                    Random.next_int());
        }

        private static File make_tmp_dir() {
            File dir;
            while(true) {
                try {
                    dir = File.new_for_path(get_random_name());
                    dir.make_directory(null);
                    return dir;
                } catch(IOError.EXISTS e) {
                    continue;
                } catch(Error e) {
                    error("Cannot create temporary directory in %s: %s",
                            tmp_dir, e.message);
                }
            }
        }

        private void do_copy(File dst, File src) throws Error {
            FileEnumerator? i = null;
            try {
                i = src.enumerate_children(
                        "standard::name",
                        FileQueryInfoFlags.NOFOLLOW_SYMLINKS, null);
            } catch(IOError.NOT_DIRECTORY e) {
                src.copy(dst, FileCopyFlags.OVERWRITE, null, null);
                return;
            }

            try { // If we didn't error out, src is a directory, so:
                dst.make_directory(null);
            } catch(IOError.EXISTS e) { /* that's ok */ }
            FileInfo? e;
            while((e = i.next_file(null)) != null) {
                do_copy(dst.get_child(e.get_name()),
                        src.get_child(e.get_name()));
            }
            i.close(null);
        }
    }
}
