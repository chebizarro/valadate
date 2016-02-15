include $(top_srcdir)/base.am
include $(top_srcdir)/build/autotools/glib-tap.mk

# --- Test exe ---
test_programs = testexe-0

testexe_0_SOURCES =  \
	testexe.vala \
	testexetwo.vala
	
testexe_0_VALAFLAGS = \
	$(VALADATE_VALAFLAGS) \
	--pkg libvaladate-1.0 \
	--vapidir $(top_builddir)/libvaladate \
	--gir testexe-0.gir \
	--library testexe \
	--target-glib=2.40.0 \
	--pkg gio-2.0 \
	-g

testexe_0_LDFLAGS =  \
	-fPIE

testexe_0_LDADD = \
	$(VALADATE_LIBS) \
	$(top_builddir)/libvaladate/libvaladate.la \
	-lgio-2.0
	
testexe_0_CPPFLAGS = \
	$(VALADATE_CPPFLAGS) \
	-DVALADATE_TESTS_DIR=\""$(VALADATE_TESTS_DIR)"\" \
	-fPIE
	
testexe_0_CFLAGS = $(VALADATE_CFLAGS) \
	-I$(top_srcdir)/libvaladate \
	-pie
	
CLEANFILES += \
	$(testexe_0_SOURCES:.vala=.c) \
	*.stamp \
	*.vapi \
	*.o \
	*.gir \
	*.gcda \
	*.gcno

DISTCLEANFILES += $(CLEANFILES)

-include $(top_srcdir)/git.mk
