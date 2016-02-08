include $(top_srcdir)/base.am
include $(top_srcdir)/build/autotools/glib-tap.mk

# --- PIE tests ---

test_programs = tests_PIE testload_PIE

tests_PIE_SOURCES =  \
	testpie.vala
	
tests_PIE_VALAFLAGS = \
	-C \
	$(VALADATE_VALAFLAGS) \
	--pkg libvaladate-1.0 \
	--vapidir $(top_builddir)/libvaladate \
	--library testpie \
	--shared-library testpie \
	--target-glib=2.40.0 \
	--pkg gio-2.0 \
	-g

tests_PIE_LDFLAGS =  \
	-fPIE

tests_PIE_LDADD = \
	$(VALADATE_LIBS) \
	$(top_builddir)/libvaladate/libvaladate.la

tests_PIE_CPPFLAGS = \
	$(VALADATE_CPPFLAGS) \
	-DVALADATE_TESTS_DIR=\""$(VALADATE_TESTS_DIR)"\" \
	-fPIE
	
tests_PIE_CFLAGS = $(VALADATE_CFLAGS) \
	-I$(top_srcdir)/libvaladate \
	-pie \
	-fPIE \
	-shared

testload_PIE_SOURCES =  \
	testloadpie.vala
	
testload_PIE_VALAFLAGS = \
	$(VALADATE_VALAFLAGS) \
	--pkg libvaladate-1.0 \
	--vapidir $(top_builddir)/libvaladate \
	--pkg gmodule-2.0 \
	--pkg gio-2.0 \
	--pkg config \
	--vapidir $(top_builddir)/vapi \
	--target-glib=2.40.0 \
	-g

testload_PIE_LDADD = \
	$(VALADATE_LIBS) \
	$(top_builddir)/libvaladate/libvaladate.la

testload_PIE_CPPFLAGS = \
	$(VALADATE_CPPFLAGS) \
	-DVALADATE_TESTS_DIR=\""$(VALADATE_TESTS_DIR)"\"
	
testload_PIE_CFLAGS = $(VALADATE_CFLAGS) \
	-I$(top_srcdir)/libvaladate \
	-I$(top_srcdir)

CLEANFILES += \
	$(tests_PIE_SOURCES:.vala=.c) \
	$(testload_PIE_SOURCES:.vala=.c) \
	*.stamp \
	*.vapi \
	*.o \
	*.html \
	*.xml

DISTCLEANFILES += $(CLEANFILES)

-include $(top_srcdir)/git.mk
