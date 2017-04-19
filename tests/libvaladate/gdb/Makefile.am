include $(top_srcdir)/base.am
#include $(top_srcdir)/build/autotools/glib-tap.mk

TESTS_ENVIRONMENT = \
	G_MESSAGES_DEBUG=all \
	G_SLICE=debug-blocks

noinst_PROGRAMS = gdb-tests-0 gdb-test-runner-0

gdb_tests_0_SOURCES =  \
	tests/gdb-test-base.vala \
	tests/test-object.vala
	
gdb_tests_0_VALAFLAGS = \
	--gir gdb-tests-0.gir \
	--library gdb-tests \
	$(TESTS_VALAFLAGS)

gdb_tests_0_LDADD = \
	$(TESTS_LIBS) \
	$(VALADATELIB) \
	$(TEST_RUNNER)

gdb_tests_0_LDFLAGS = \
	-pie
	
gdb_tests_0_CFLAGS = \
	$(TESTS_CFLAGS) \
	-fPIE

# test-runner

gdb_test_runner_0_SOURCES =  \
	test-runner.vala
	
gdb_test_runner_0_VALAFLAGS = \
	--pkg config \
	--gir gdb-test-runner-0.gir \
	--library gdb-test-runner \
	$(TESTS_VALAFLAGS)

gdb_test_runner_0_LDADD = \
	$(TESTS_LIBS) \
	$(VALADATELIB) \
	$(TEST_RUNNER)

gdb_test_runner_0_CPPFLAGS = \
	$(TESTS_CPPFLAGS) \
	-fPIE
	
gdb_test_runner_0_CFLAGS = \
	$(TESTS_CFLAGS) \
	-pie

#TESTS = run-tests.py

gdb-tests-0-gdb.py: gdb-tests-0-gdb.py.in
	$(AM_V_GEN) $(SED) -e "s|\@topsrcdir\@|$(top_srcdir)|" $(srcdir)/gdb-tests-0-gdb.py.in > $(builddir)/gdb-tests-0-gdb.py

noinst_DATA = \
	gdb-tests-0-gdb.py

CLEANFILES += \
	*.vapi \
	*.gir

-include $(top_srcdir)/git.mk
