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

namespace Valadate {
    public class TempDir : Object {
        // SECTION: static data
        private static string orig_dir = Environment.get_current_dir();
        private static string tmp_dir = Environment.get_tmp_dir();

        public class string get_orig_dir_name() {
            return orig_dir;
        }

        public class string get_tmp_dir_name() {
            return tmp_dir;
        }

        // SECTION: Members and properties
        private File _dir = make_tmp_dir();
        public File dir { get { return _dir; } }
        public File src_dir { owned get { return File.new_for_path(orig_dir); } }

        // SECTION: Utility methods
        public File file(string path) {
            return dir.resolve_relative_path(path);
        }

        public string contents(string path) {
            string r;
            try {
                file(path).load_contents(null, out r, null, null);
            } catch(Error e) {
                error("Failed to read content from \"%s\": %s", path,
                        e.message);
            }
            return r;
        }

        // SECTION: Initialization
        public TempDir store(string path, string content) {
            File f = file(path);
            try {
                try {
                    f.get_parent().make_directory_with_parents(null);
                } catch(IOError.EXISTS e) {}
                f.replace_contents(content, content.size(), null, false,
                        FileCreateFlags.REPLACE_DESTINATION, null, null);
            } catch(Error e) {
                error("Failed to write to \"%s\": %s", path, e.message);
            }
            return this;
        }

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

        public TempDir shell(string path, string code) {
            File test_dir = file(path);
            try {
                test_dir.make_directory_with_parents(null);
            } catch(IOError.EXISTS e) { /* that's ok */ }
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
