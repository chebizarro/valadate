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
        private override void visit_namespace (Vala.Namespace ns) {
            if(ns.external_package)
                return;
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

        private override void visit_class (Vala.Class cl) {
            if(cl.external_package)
                return;
            if(!is_fixture(cl))
                return;
            if(verbose)
                stdout.printf("    Found fixture %s (%sget_type)\n", cl.get_full_name(), cl.get_lower_case_cprefix());
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
