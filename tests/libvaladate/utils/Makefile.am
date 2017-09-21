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
	$(TESTS_CPPFLAGS)
	
testutils_0_CFLAGS = \
	$(TESTS_CFLAGS)

if NATIVE_WIN32
testutils_0_CFLAGS += \
	-Wl,--export-all-symbols
else
testutils_0_CFLAGS += \
	-pie
testutils_0_CPPFLAGS += \
	-fPIE
endif


GITIGNOREFILES = \
	*.gir \
	*.test \
	*.vapi

-include $(top_srcdir)/git.mk
