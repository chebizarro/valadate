include $(top_srcdir)/base.am
include $(top_srcdir)/build/autotools/glib-tap.mk

# --- Test exe ---

#bin_PROGRAMS = testexe
test_programs = testexe

testexe_SOURCES =  \
	testexe.vala
	
testexe_VALAFLAGS = \
	-C \
	$(VALADATE_VALAFLAGS) \
	--pkg libvaladate-1.0 \
	--vapidir $(top_builddir)/libvaladate \
	--gir testexe-0.gir \
	--library testexe \
	--shared-library testexe \
	--target-glib=2.40.0 \
	--pkg gio-2.0 \
	-g

testexe_LDFLAGS =  \
	-fPIE

testexe_LDADD = \
	$(VALADATE_LIBS) \
	$(top_builddir)/libvaladate/libvaladate.la \
	$(top_builddir)/libvaladate/librunner.la

testexe_CPPFLAGS = \
	$(VALADATE_CPPFLAGS) \
	-DVALADATE_TESTS_DIR=\""$(VALADATE_TESTS_DIR)"\" \
	-fPIE
	
testexe_CFLAGS = $(VALADATE_CFLAGS) \
	-I$(top_srcdir)/libvaladate \
	-pie \
	-fPIE \
	-shared


CLEANFILES += \
	$(testexe_SOURCES:.vala=.c) \
	*.stamp \
	*.vapi \
	*.o \
	*.gir

DISTCLEANFILES += $(CLEANFILES)

-include $(top_srcdir)/git.mk
