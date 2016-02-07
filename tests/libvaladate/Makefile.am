include $(top_srcdir)/base.am
include $(top_srcdir)/build/autotools/glib-tap.mk

test_programs = tests_libvaladate

tests_libvaladate_SOURCES =  \
	main.vala
	
tests_libvaladate_VALAFLAGS = \
	$(VALADATE_VALAFLAGS) \
	--pkg libvaladate-1.0 \
	--vapidir $(top_builddir)/libvaladate \
	-g

tests_libvaladate_LDADD = \
	$(VALADATE_LIBS) \
	$(top_builddir)/libvaladate/libvaladate.la

tests_libvaladate_CPPFLAGS = \
	$(VALADATE_CPPFLAGS)
	
tests_libvaladate_CFLAGS = $(VALADATE_CFLAGS) \
	-I$(top_srcdir)/libvaladate

CLEANFILES += \
	$(tests_libvaladate_SOURCES:.vala=.c) \
	*.stamp \
	*.html \
	*.xml

DISTCLEANFILES += $(CLEANFILES)


-include $(top_srcdir)/git.mk
