include $(top_srcdir)/base.am
include $(top_srcdir)/build/autotools/glib-tap.mk

# --- PIE tests ---

# tests_PIE is a test binary compiled as a PIE

test_programs = tests_PIE

tests_PIE_SOURCES =  \
	testpie.vala
	
tests_PIE_VALAFLAGS = \
	-C \
	$(VALADATE_VALAFLAGS) \
	--pkg libvaladate-1.0 \
	--vapidir $(top_builddir)/libvaladate \
	--gir tests_PIE-0.gir \
	--library tests_PIE \
	--shared-library tests_PIE \
	--target-glib=2.40.0 \
	--pkg gio-2.0 \
	-g

tests_PIE_LDFLAGS =  \
	-fPIE

tests_PIE_LDADD = \
	$(VALADATE_LIBS) \
	$(top_builddir)/libvaladate/libvaladate.la \
	$(top_builddir)/libvaladate/librunner.la

tests_PIE_CPPFLAGS = \
	$(VALADATE_CPPFLAGS) \
	-DVALADATE_TESTS_DIR=\""$(VALADATE_TESTS_DIR)"\" \
	-fPIE
	
tests_PIE_CFLAGS = $(VALADATE_CFLAGS) \
	-I$(top_srcdir)/libvaladate \
	-pie \
	-fPIE \
	-shared

# testload_PIE is a test binary that attempts to load the tests_PIE binary

test_programs += testload_PIE

testload_PIE_SOURCES =  \
	testloadpie.vala
	
testload_PIE_VALAFLAGS = \
	$(VALADATE_VALAFLAGS) \
	--pkg libvaladate-1.0 \
	--vapidir $(top_builddir)/libvaladate \
	--gir testload_PIE-0.gir \
	--library testload_PIE \
	--shared-library testload_PIE \
	--pkg gmodule-2.0 \
	--pkg gio-2.0 \
	--pkg config \
	--vapidir $(top_builddir)/vapi \
	--target-glib=2.40.0 \
	-g

testload_PIE_LDADD = \
	$(VALADATE_LIBS) \
	$(top_builddir)/libvaladate/libvaladate.la \
	$(top_builddir)/libvaladate/librunner.la

testload_PIE_CPPFLAGS = \
	$(VALADATE_CPPFLAGS) \
	-DVALADATE_TESTS_DIR=\""$(VALADATE_TESTS_DIR)"\"
	
testload_PIE_CFLAGS = $(VALADATE_CFLAGS) \
	-I$(top_srcdir)/libvaladate \
	-I$(top_srcdir) \
	-pie \
	-fPIE \
	-shared

testload_PIE_LDFLAGS =  \
	-fPIE

CLEANFILES += \
	$(tests_PIE_SOURCES:.vala=.c) \
	$(testload_PIE_SOURCES:.vala=.c) \
	*.stamp \
	*.vapi \
	*.o \
	*.html \
	*.xml \
	*.gcda \
	*.gcno \
	*.gir

DISTCLEANFILES += $(CLEANFILES)

-include $(top_srcdir)/git.mk
