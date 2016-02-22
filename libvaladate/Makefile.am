include $(top_srcdir)/base.am
include $(top_srcdir)/libvaladate/libvaladate.am

data/resources.c: $(top_srcdir)/libvaladate/data/valadate.gresource.xml $(shell $(GLIB_COMPILE_RESOURCES) --generate-dependencies \
--sourcedir=$(top_srcdir)/libvaladate/data/ $(top_srcdir)/libvaladate/data/valadate.gresource.xml)
	$(AM_V_GEN) $(GLIB_COMPILE_RESOURCES) --target=$@ --sourcedir=$(top_srcdir)/libvaladate/data/ --generate-source $<

lib_LTLIBRARIES = libvaladate-1.0.la

libvaladate_1_0_la_SOURCES = \
	data/resources.c \
	$(libvaladate_sources)

libvaladate_1_0_la_CFLAGS = \
	$(VALADATE_CFLAGS)

libvaladate_1_0_la_CPPLAGS = \
	$(VALADATE_CPPFLAGS)

libvaladate_1_0_la_VALAFLAGS = \
	$(VALADATE_VALAFLAGS) \
	--gresources $(top_srcdir)/libvaladate/data/valadate.gresource.xml \
	--shared-library libvaladate-1.0 \
	--library libvaladate-1.0 \
	--vapi libvaladate-1.0.vapi \
	-H libvaladate-1.0.h \
	--gir=Valadate-1.0.gir

libvaladate_1_0_la_LIBADD = \
	$(VALADATE_LIBS) \
	-lgio-2.0

if PLATFORM_WIN32
libvaladate_1_0_la_LDFLAGS = -no-undefined
endif

if NATIVE_WIN32
libvaladate_1_0_la_LDFLAGS = -export-dynamic
endif

libvaladate_1_0_includedir = \
	$(includedir)/libvaladate-1.0

libvaladate_1_0_include_HEADERS = \
	libvaladate-1.0.h

vapidir = \
	$(datadir)/vala/vapi

dist_vapi_DATA = \
	libvaladate-1.0.vapi \
	libvaladate-1.0.deps

pkgconfigdir = \
	$(libdir)/pkgconfig

pkgconfig_DATA = \
	libvaladate-1.0.pc

EXTRA_DIST = \
	libvaladate-1.0.pc.in

noinst_DATA =
	$(gresource_file)

CLEANFILES += \
	$(libvaladate_1_0_la_SOURCES:.vala=.c) \
	data/*.c \
	*.vapi \
	*.h \
	*.gir \
	*.pc

DISTCLEANFILES += $(CLEANFILES)

MAINTAINERCLEANFILES = $(DISTCLEANFILES)

-include $(top_srcdir)/git.mk
