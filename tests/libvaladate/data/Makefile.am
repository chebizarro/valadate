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
	$(TESTS_CPPFLAGS)
	
testexe_0_CFLAGS = \
	$(TESTS_CFLAGS) \
	-I$(top_srcdir)/libvaladate/include
	

if PLATFORM_WIN32

testexe_0_LDFLAGS = -Wl,--export-all-symbols,--out-implib=testexe-0.dll.a

else

testexe_0_LDFLAGS = -rdynamic
testexe_0_CPPFLAGS += -fPIE
testexe_0_CFLAGS += -pie

endif


helloworld_SOURCES =  \
	helloworld.vala

GITIGNOREFILES = \
	*.gir \
	*.test \
	*.vapi

-include $(top_srcdir)/git.mk
