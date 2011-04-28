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
using Vala;

namespace ValadateRunner {
    class VapiReader: Object, Reader {
        private CodeContext context;

        public bool process_file(string file) throws Error {
            return add_file(file);
        }

        public bool add_file(string file) throws Error {
            if(!file.has_suffix(".vapi"))
                return false;
            if(verbose)
                stdout.printf("Reading %s\n", file);
            if(!FileUtils.test(file, FileTest.EXISTS))
                throw new FileError.NOENT("%s does not exist.", file);

            // Note: everything must be package, otherwise the analyzer would complain
            context.add_source_file(
                new SourceFile(context, SourceFileType.PACKAGE, file)); // FIXME: Do we need realpath?

            var deps = file.substring(0, file.length - 4) + "deps";
            if(FileUtils.test(deps, FileTest.EXISTS)) {
                string deps_content;
                FileUtils.get_contents(deps, out deps_content, null);
                foreach(string dep in deps_content.split("\n")) {
                    dep = dep.strip();
                    if(dep != "")
                        add_package(dep);
                }
            }
            return true;
        }

        public void gather_tests() throws Error {
            check();
            // parse everything
            if(verbose)
                stdout.printf("Parsing...\n");
            var parser = new Parser();
            parser.parse(context);
            check();
            // Resolve symbols
            if(verbose)
                stdout.printf("Resolving...\n");
            var resolver = new SymbolResolver();
            resolver.resolve(context);
            check();
            /*// Analyze code (XXX: do we have to?)
            if(verbose)
                stdout.printf("Analyzing...\n");
            var analyzer = new SemanticAnalyzer();
            analyzer.analyze(context);
            check();*/
            // Now we should have all data gathered, so run our visitor
            if(verbose)
                stdout.printf("Gathering tests...\n");
            var gatherer = new VapiTestGatherer();
            gatherer.gather(context);
        }

        public VapiReader() throws Error {
            // Create a CodeContext for the parsing.
            context = new CodeContext();
            CodeContext.push(context);
            // setup the context
            context.ccode_only = true;
            // only gobject profile is supported (XXX: and why the heck do
            // I have to define the symbols myself).
            context.profile = Profile.GOBJECT;
            context.add_define ("GOBJECT");
#if VALA_0_7_6_NEW_METHODS
            context.add_define ("VALA_0_7_6_NEW_METHODS");
#endif
            // add default packages
            add_package("glib-2.0");
            add_package("gobject-2.0");
            add_package("gio-2.0");
            add_package("valadate-1.0");
        }

        ~VapiReader() {
            CodeContext.pop();
        }

        private void add_package(string pkg) throws Error {
            if(verbose)
                stdout.printf("Adding package %s\n", pkg);
            if(context.has_package(pkg))
                return;

            context.vapi_directories = path;
            var pkg_path = context.get_vapi_path(pkg);
            if(pkg_path == null)
                throw new RunnerError.NOT_FOUND("Dependent package %s was not found. Need to add search dir?", pkg);
            context.add_package(pkg);
            add_file(pkg_path);
        }

        private void check() throws Error {
            if(context.report.get_errors() > 0)
                throw new RunnerError.VAPI_ERROR("Found %i errors parsing specified vapi files.", context.report.get_errors());
        }
    }
}
