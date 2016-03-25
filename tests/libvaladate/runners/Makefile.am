include $(top_srcdir)/base.am
include $(top_srcdir)/build/autotools/glib-tap.mk

# --- Test exe ---
test_programs = testgtk-0

testgtk_0_SOURCES =  \
	testgtk.vala
	
testgtk_0_VALAFLAGS = \
	$(TESTS_GTK_VALAFLAGS) \
	--gir testgtk-0.gir \
	--library Tests

testgtk_0_LDADD = \
	$(top_builddir)/libvaladate/libvaladate-1.0.la \
	$(top_builddir)/libvaladate/libvaladate-gtk-1.0.la \
	$(TESTS_GTK_LIBS) \
	-lgio-2.0
	
testgtk_0_CPPFLAGS = \
	$(TESTS_GTK_CPPFLAGS) \
	-fPIE
	
testgtk_0_CFLAGS = \
	$(TESTS_GTK_CFLAGS) \
	-pie
	
CLEANFILES += \
	$(testgtk_0_SOURCES:.vala=.c) \
	*.vapi \
	*.gir

DISTCLEANFILES += $(CLEANFILES)

-include $(top_srcdir)/git.mk
