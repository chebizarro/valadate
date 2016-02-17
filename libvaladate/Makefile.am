include $(top_srcdir)/base.am
include $(top_srcdir)/libvaladate/libvaladate.am

data/resources.c: $(top_srcdir)/libvaladate/data/valadate.gresource.xml $(shell $(GLIB_COMPILE_RESOURCES) --generate-dependencies \
--sourcedir=$(top_srcdir)/libvaladate/data/ $(top_srcdir)/libvaladate/data/valadate.gresource.xml)
	$(AM_V_GEN) $(GLIB_COMPILE_RESOURCES) --target=$@ --sourcedir=$(top_srcdir)/libvaladate/data/ --generate-source $<

lib_LTLIBRARIES = libvaladate.la

libvaladate_la_SOURCES = \
	data/resources.c \
	$(libvaladate_sources)

libvaladate_la_CFLAGS = \
	$(VALADATE_CFLAGS)

libvaladate_la_CPPLAGS = \
	$(VALADATE_CPPFLAGS)

libvaladate_la_VALAFLAGS = \
	$(VALADATE_VALAFLAGS) \
	--gresources $(top_srcdir)/libvaladate/data/valadate.gresource.xml \
	--shared-library libvaladate-1.0 \
	--library libvaladate-1.0 \
	--vapi libvaladate-1.0.vapi \
	-H libvaladate.h \
	--gir=Valadate-1.0.gir

libvaladate_la_LIBADD = \
	$(VALADATE_LIBS) \
	-lgio-2.0

noinst_DATA =
	$(gresource_file)


CLEANFILES += \
	$(libvaladate_la_SOURCES:.vala=.c) \
	data/*.c \
	*.vapi \
	*.h \
	*.gir \
	*.pc

DISTCLEANFILES += $(CLEANFILES)

MAINTAINERCLEANFILES = $(DISTCLEANFILES)

-include $(top_srcdir)/git.mk
