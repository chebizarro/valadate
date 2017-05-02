include $(top_srcdir)/base.am
include $(top_srcdir)/build/autotools/glib-tap.mk

TESTS_ENVIRONMENT += \
	G_MESSAGES_DEBUG=all \
	G_SLICE=debug-blocks

#LOG_COMPILER = $(top_srcdir)/build/autotools/tap-test
#SUBDIRS = data

test_programs = tests_libvaladate

#log_file = $(VALADATE_TESTS_DIR)/results/ # Where to save the result and output of the test script.
#trs_file = $(VALADATE_TESTS_DIR)/results/ # Where to save the metadata of the test run.


tests_libvaladate_SOURCES =  \
	main.vala \
	mocks.vala \
	assembly.vala \
	asynctestrunner.vala \
	girtestplan.vala \
	gnutestreportprinter.vala \
	taptestresultprinter.vala \
	testadapter.vala \
	testassembly.vala \
	testcase.vala \
	testplan.vala \
	testreport.vala \
	testresult.vala \
	testsuite.vala \
	vapitestplan.vala \
	xmltestreportprinter.vala
	
tests_libvaladate_VALAFLAGS = \
	$(TESTS_VALAFLAGS)

tests_libvaladate_LDADD = \
	$(TESTS_LIBS) \
	$(VALADATELIB)

tests_libvaladate_CPPFLAGS = \
	$(TESTS_CPPFLAGS)
	
tests_libvaladate_CFLAGS = \
	$(TESTS_CFLAGS)

GITIGNOREFILES = \
	*.gir \
	*.test \
	*.vapi

-include $(top_srcdir)/git.mk
