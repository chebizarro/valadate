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
	--library testexe-0 \
	--symbols testexe-0.test

testexe_0_LDADD = \
	$(TESTS_LIBS) \
	$(TEST_RUNNER) \
	-lm
	
testexe_0_CPPFLAGS = \
	$(TESTS_CPPFLAGS) \
	-fPIE
	
testexe_0_CFLAGS = \
	$(TESTS_CFLAGS) \
	-I$(top_srcdir)/libvaladate/include \
	-pie

if PLATFORM_WIN32
testexe_0_CPPFLAGS += \
	-Wl,-export-all-symbols \
	-Wl,-out-implib testexe-0.exe.a
endif


helloworld_SOURCES =  \
	helloworld.vala

GITIGNOREFILES = \
	*.gir \
	*.test \
	*.vapi

-include $(top_srcdir)/git.mk
