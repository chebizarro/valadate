include $(top_srcdir)/base.am
include $(top_srcdir)/build/autotools/glib-tap.mk

# --- Test exe ---
test_programs = testgenie
#bin_PROGRAMS = testgenie

testgenie.c: testgenie.gs
	$(VALAC) -C $< $(testgenie_VALAFLAGS)

testgenie_SOURCES = testgenie.c
	
testgenie_VALAFLAGS = \
	$(VALADATE_VALAFLAGS) \
	--pkg gio-2.0 \
	--pkg libvaladate-1.0 \
	--vapidir $(top_builddir)/libvaladate \
	--gir testgenie-0.gir \
	--shared-library testgenie \
	--library testgenie \
	--target-glib=2.40.0 \
	-g

testgenie_LDFLAGS =  \
	-fPIE

testgenie_LDADD = \
	$(VALADATE_LIBS) \
	$(top_builddir)/libvaladate/libvaladate.la
	
testgenie_CPPFLAGS = \
	$(VALADATE_CPPFLAGS) \
	-DVALADATE_TESTS_DIR=\""$(VALADATE_TESTS_DIR)"\" \
	-fPIE
	
testgenie_CFLAGS = $(VALADATE_CFLAGS) \
	-I$(top_srcdir)/libvaladate \
	-pie
	
CLEANFILES += \
	$(testgenie_SOURCES:.gs=.c) \
	*.stamp \
	*.o \
	*.gir \
	*.gcda \
	*.gcno

DISTCLEANFILES += $(CLEANFILES)

-include $(top_srcdir)/git.mk
