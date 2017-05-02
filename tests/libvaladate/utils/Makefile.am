include $(top_srcdir)/base.am
include $(top_srcdir)/build/autotools/glib-tap.mk

test_programs = testutils-0

testutils_0_SOURCES =  \
	testsignalwaiter.vala \
	wait.vala
	
testutils_0_VALAFLAGS = \
	--gir testutils-0.gir \
	--library testutils-0 \
	$(TESTS_VALAFLAGS)

testutils_0_LDADD = \
	$(TESTS_LIBS) \
	$(VALADATELIB) \
	$(TEST_RUNNER)

testutils_0_CPPFLAGS = \
	-fPIE \
	$(TESTS_CPPFLAGS)
	
testutils_0_CFLAGS = \
	-pie \
	$(TESTS_CFLAGS)

GITIGNOREFILES = \
	*.gir \
	*.test \
	*.vapi

-include $(top_srcdir)/git.mk
