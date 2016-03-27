include $(top_srcdir)/base.am
include $(top_srcdir)/libvaladate/libvaladate.am

data/resources.c: $(top_srcdir)/libvaladate/data/valadate.gresource.xml $(shell $(GLIB_COMPILE_RESOURCES) --generate-dependencies \
--sourcedir=$(top_srcdir)/libvaladate/data/ $(top_srcdir)/libvaladate/data/valadate.gresource.xml)
	$(AM_V_GEN) $(GLIB_COMPILE_RESOURCES) --target=$@ --sourcedir=$(top_srcdir)/libvaladate/data/ --generate-source $<

lib_LTLIBRARIES = libvaladate-1.0.la libvaladate-cli-1.0.la

# The main valadate library which contains the framework and utilities

libvaladate_1_0_la_SOURCES = \
	data/resources.c \
	$(libvaladate_sources)

libvaladate_1_0_la_CFLAGS = \
	$(VALADATE_CFLAGS)
	
libvaladate_1_0_la_CPPLAGS = \
	-fPIE \
	$(VALADATE_CPPFLAGS)

libvaladate_1_0_la_VALAFLAGS = \
	$(VALADATE_VALAFLAGS) \
	--gresources $(top_srcdir)/libvaladate/data/valadate.gresource.xml \
	--library libvaladate-1.0 \
	--vapi libvaladate-1.0.vapi \
	-H libvaladate-1.0.h \
	--gir=Valadate-1.0.gir

libvaladate_1_0_la_LDFLAGS = \
	-export-dynamic \
	-shared
	
libvaladate_1_0_la_LIBADD = \
	$(VALADATE_LIBS) \
	-lgio-2.0

# includes
libvaladate_1_0includedir = \
	$(includedir)/libvaladate-1.0

libvaladate_1_0include_HEADERS = \
	libvaladate-1.0.h


# The cli library which bootstraps cl tests

libvaladate_cli_1_0_la_SOURCES = \
	cli-main.vala

libvaladate_cli_1_0_la_CFLAGS = \
	$(VALADATE_CLI_CFLAGS) \
	-I$(top_srcdir)/libvaladate

libvaladate_cli_1_0_la_CPPLAGS = \
	$(VALADATE_CLI_CPPFLAGS)

libvaladate_cli_1_0_la_VALAFLAGS = \
	$(VALADATE_CLI_VALAFLAGS) \
	--pkg libvaladate-1.0 \
	--vapidir $(top_builddir)/libvaladate \
	--vapidir $(top_builddir)/vapi \
	--library valadate-1.0 \
	--vapi valadate-1.0.vapi \
	-H valadate-1.0.h

libvaladate_cli_1_0_la_LIBADD = \
	$(VALADATE_CLI_LIBS) \
	-dlopen	$(VALADATELIB)

# includes
libvaladate_cli_1_0includedir = \
	$(includedir)/valadate-1.0

libvaladate_cli_1_0include_HEADERS = \
	valadate-1.0.h

# Platform specific flags

if PLATFORM_WIN32
libvaladate_1_0_la_LDFLAGS += -no-undefined
libvaladate_cli_1_0_la_LDFLAGS = -no-undefined
endif

if NATIVE_WIN32
libvaladate_1_0_la_LDFLAGS += -export-dynamic
libvaladate_cli_1_0_la_LDFLAGS = -export-dynamic
endif



# vapis
vapidir = \
	$(datadir)/vala/vapi

dist_vapi_DATA = \
	libvaladate-1.0.vapi \
	libvaladate-1.0.deps \
	valadate-1.0.vapi \
	valadate-1.0.deps

# pkg-config
pkgconfigdir = \
	$(libdir)/pkgconfig

pkgconfig_DATA = \
	libvaladate-1.0.pc \
	valadate-1.0.pc

EXTRA_DIST = \
	libvaladate-1.0.pc.in \
	valadate-1.0.pc.in

noinst_DATA =
	$(gresource_file)

CLEANFILES += \
	$(libvaladate_1_0_la_SOURCES:.vala=.c) \
	$(libvaladate_cli_1_0_la_SOURCES:.vala=.c) \
	data/*.c \
	*.vapi \
	*.h \
	*.gir \
	*.pc

DISTCLEANFILES += $(CLEANFILES)

MAINTAINERCLEANFILES = $(DISTCLEANFILES)

.NOTPARALLEL: noinst_LTLIBRARIES

-include $(top_srcdir)/git.mk
