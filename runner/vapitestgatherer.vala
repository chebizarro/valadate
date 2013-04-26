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
    class VapiTestGatherer : CodeVisitor {
        private static SList<VapiSuiteInfo> suites = null;

        private TestSuite current_suite = null;

        public void gather(CodeContext context) {
            context.accept(this);
        }

        // Visitation methods
        public override void visit_namespace (Vala.Namespace ns) {
            if(verbose)
                stdout.printf("Scanning namespace %s...\n", ns.name);

            var prev_suite = current_suite;
            if(ns.name == null)
                current_suite = TestSuite.get_root();
            else {
                current_suite = new TestSuite(ns.name);
                prev_suite.add_suite(current_suite);
            }
            ns.accept_children(this); // XXX: We are probably only interested in namespaces and classes
            current_suite = prev_suite;
        }

        public override void visit_class (Vala.Class cl) {
            if(!is_fixture(cl))
                return;
            if(verbose)
                stdout.printf("    Found fixture %s (%sget_type)\n", cl.get_full_name(),
                    Vala.CCodeBaseModule.get_ccode_lower_case_prefix(cl));
            try {
                var suite_info = new VapiSuiteInfo(cl);
                var suite = new TestSuite(cl.name);
                suite_info.create_tests(suite);
                current_suite.add_suite(suite);
                suites.prepend((owned)suite_info);
            } catch(RunnerError e) {
                stderr.printf("Error: %s\n", e.message);
            }
        }

        // Auxiliaries
        private bool is_fixture(Class cl) {
            foreach(var base_type in cl.get_base_types()) {
                var obj_type = (ObjectType)base_type;
                if(obj_type.type_symbol.get_full_name() == "Valadate.Fixture")
                    return true;
            }
            return false;
        }
    }
}
