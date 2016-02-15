include $(top_srcdir)/base.am
include $(top_srcdir)/build/autotools/glib-tap.mk

# --- Test exe ---
test_programs = testgenie-0

testgenie.c: testgenie.gs
	$(VALAC) -C $< $(testgenie_0_VALAFLAGS)

testgenie_0_SOURCES = testgenie.c
	
testgenie_0_VALAFLAGS = \
	$(VALADATE_VALAFLAGS) \
	--pkg gio-2.0 \
	--pkg libvaladate-1.0 \
	--vapidir $(top_builddir)/libvaladate \
	--gir testgenie-0.gir \
	--shared-library testgenie \
	--library testgenie \
	--target-glib=2.40.0 \
	-g

testgenie_0_LDFLAGS =  \
	-fPIE

testgenie_0_LDADD = \
	$(VALADATE_LIBS) \
	$(top_builddir)/libvaladate/libvaladate.la
	
testgenie_0_CPPFLAGS = \
	$(VALADATE_CPPFLAGS) \
	-DVALADATE_TESTS_DIR=\""$(VALADATE_TESTS_DIR)"\" \
	-fPIE
	
testgenie_0_CFLAGS = $(VALADATE_CFLAGS) \
	-I$(top_srcdir)/libvaladate \
	-pie
	
CLEANFILES += \
	$(testgenie_0_SOURCES:.gs=.c) \
	*.stamp \
	*.o \
	*.gir \
	*.gcda \
	*.gcno \
	*.vapi

DISTCLEANFILES += $(CLEANFILES)

-include $(top_srcdir)/git.mk
