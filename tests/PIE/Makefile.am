include $(top_srcdir)/base.am
include $(top_srcdir)/build/autotools/glib-tap.mk

# --- PIE tests ---

# tests_PIE is a test binary compiled as a PIE

test_programs = tests_PIE-0

tests_PIE_0_SOURCES =  \
	testpie.vala
	
tests_PIE_0_VALAFLAGS = \
	$(TESTS_VALAFLAGS) \
	--pkg gmodule-2.0 \
	--gir tests_PIE-0.gir \
	--library tests_PIE

#tests_PIE_0_LDFLAGS =  -fPIE

tests_PIE_0_LDADD = \
	$(TESTS_LIBS) \
	-lgio-2.0

tests_PIE_0_CPPFLAGS = \
	$(TESTS_CPPFLAGS) \
	-fPIE
	
tests_PIE_0_CFLAGS = \
	$(TESTS_CFLAGS) \
	-pie

# testload_PIE is a test binary that attempts to load the tests_PIE binary

test_programs += testload_PIE-0

testload_PIE_0_SOURCES =  \
	testloadpie.vala
	
testload_PIE_0_VALAFLAGS = \
	$(VALADATE_VALAFLAGS) \
	--pkg libvaladate-1.0 \
	--vapidir $(top_builddir)/libvaladate \
	--gir testload_PIE-0.gir \
	--library testload_PIE

testload_PIE_0_LDADD = \
	$(VALADATE_LIBS) \
	$(top_builddir)/libvaladate/libvaladate.la

testload_PIE_0_CPPFLAGS = \
	$(VALADATE_CPPFLAGS) \
	-DVALADATE_TESTS_DIR=\""$(VALADATE_TESTS_DIR)"\"
	
testload_PIE_0_CFLAGS = $(VALADATE_CFLAGS) \
	-I$(top_srcdir)/libvaladate \
	-I$(top_srcdir) \
	-pie \
	-fPIE \
	-shared

testload_PIE_0_LDFLAGS =  \
	-fPIE

CLEANFILES += \
	$(tests_PIE_0_SOURCES:.vala=.c) \
	$(testload_PIE_0_SOURCES:.vala=.c) \
	*.stamp \
	*.vapi \
	*.o \
	*.html \
	*.xml \
	*.gcda \
	*.h \
	*.gcno \
	*.gir

DISTCLEANFILES += $(CLEANFILES)

-include $(top_srcdir)/git.mk
