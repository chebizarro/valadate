include $(top_srcdir)/base.am
#include $(top_srcdir)/build/autotools/glib-tap.mk

# --- Test exe ---
#test_programs = testexe-0
noinst_PROGRAMS = testexe-0 helloworld

testexe_0_SOURCES =  \
	testexe.vala \
	testexetwo.vala
	
testexe_0_VALAFLAGS = \
	$(TESTS_VALAFLAGS) \
	--vapi-comments \
	--pkg gmodule-2.0 \
	--gir testexe-0.gir \
	--library testexe-0

testexe_0_LDADD = \
	$(TESTS_LIBS) \
	$(VALADATELIB) \
	$(TEST_RUNNER) \
	-lm
	
testexe_0_CPPFLAGS = \
	$(TESTS_CPPFLAGS)
	
testexe_0_CFLAGS = \
	$(TESTS_CFLAGS) \
	-I$(top_builddir)/libvaladate/include

if NATIVE_WIN32
testexe_0_CFLAGS += \
	-Wl,--export-all-symbols
else
testexe_0_CFLAGS += \
	-pie
testexe_0_CPPFLAGS += \
	-fPIE
endif


helloworld_SOURCES =  \
	helloworld.vala

GITIGNOREFILES = \
	*.gir \
	*.test \
	*.vapi

-include $(top_srcdir)/git.mk
