include $(top_srcdir)/base.am
include $(top_srcdir)/build/autotools/glib-tap.mk

# --- PIE tests ---

# tests_PIE is a test binary compiled as a PIE

test_programs = tests_PIE-0 testload_PIE-0

tests_PIE_0_SOURCES =  \
	testpie.vala
	
tests_PIE_0_VALAFLAGS = \
	$(TESTS_VALAFLAGS) \
	--pkg gmodule-2.0 \
	--gir tests_PIE-0.gir \
	--library tests_PIE

tests_PIE_0_LDADD = \
	$(TESTS_LIBS) \
	$(VALADATELIB) \
	$(TEST_RUNNER) \
	-lgio-2.0

tests_PIE_0_CPPFLAGS = \
	$(TESTS_CPPFLAGS) \
	-fPIE
	
tests_PIE_0_CFLAGS = \
	$(TESTS_CFLAGS) \
	-pie

# testload_PIE is a test binary that attempts to load the tests_PIE binary

testload_PIE_0_SOURCES =  \
	testloadpie.vala
	
testload_PIE_0_VALAFLAGS = \
	$(TESTS_VALAFLAGS) \
	--pkg gmodule-2.0 \
	--gir testload_PIE-0.gir \
	--library testload_PIE

if PLATFORM_DARWIN
testload_PIE_0_VALAFLAGS += -D MACOSX
endif

testload_PIE_0_LDADD = \
	$(TESTS_LIBS) \
	$(VALADATELIB) \
	$(TEST_RUNNER) \
	-lgio-2.0
	
testload_PIE_0_CPPFLAGS = \
	$(TESTS_CPPFLAGS) \
	-fPIE \
	-DVALADATE_TESTS_DIR=\""$(VALADATE_TESTS_DIR)"\"
	
testload_PIE_0_CFLAGS = \
	$(TESTS_CFLAGS) \
	-pie

CLEANFILES += \
	$(tests_PIE_0_SOURCES:.vala=.c) \
	$(testload_PIE_0_SOURCES:.vala=.c) \
	*.gir \
	*.vapi

DISTCLEANFILES += $(CLEANFILES)

-include $(top_srcdir)/git.mk
