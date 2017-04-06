include $(top_srcdir)/base.am
include $(top_srcdir)/libvaladate/libvaladate.am

SUBDIRS = . drivers

lib_LTLIBRARIES = libvaladate-2.0.la libvaladate-cli-2.0.la

# The main valadate library which contains the framework and utilities

libvaladate_2_0_la_SOURCES = \
	$(libvaladate_sources)

libvaladate_2_0_la_CFLAGS = \
	$(COVERAGE_CFLAGS) \
	$(VALADATE_CFLAGS) \
	-DVALADATE_DRIVER_DIR=\""$(VALADATE_DRIVER_DIR)"\" \
	-g \
	-Og
	
libvaladate_2_0_la_CPPLAGS = \
	$(VALADATE_CPPFLAGS) \
	-fPIE

libvaladate_2_0_la_VALAFLAGS = \
	$(VALADATE_VALAFLAGS) \
	--library libvaladate \
	--vapi vapi/libvaladate-2.0.vapi \
	-H include/libvaladate.h \
	--gir=Valadate-2.0.gir \
	-g

libvaladate_2_0_la_LDFLAGS = \
	-version-info $(LT_CURRENT):$(LT_REVISION):$(LT_AGE) \
	-export-dynamic \
	-shared
	
libvaladate_2_0_la_LIBADD = \
	$(COVERAGE_LIBS) \
	$(VALADATE_LIBS)

# includes
libvaladate_1_0includedir = \
	$(includedir)/valadate

libvaladate_1_0include_HEADERS = \
	include/libvaladate.h

# The cli library which bootstraps cl tests

libvaladate_cli_2_0_la_SOURCES = \
	cli/cli-main.vala

libvaladate_cli_2_0_la_CFLAGS = \
	$(COVERAGE_CFLAGS) \
	$(VALADATE_CLI_CFLAGS) \
	-I$(top_srcdir)/libvaladate/include \
	-g -Og

libvaladate_cli_2_0_la_CPPLAGS = \
	$(VALADATE_CLI_CPPFLAGS)

libvaladate_cli_2_0_la_VALAFLAGS = \
	--pkg libvaladate-2.0 \
	--vapidir $(top_builddir)/libvaladate/vapi \
	--vapidir $(top_builddir)/vapi \
	--library valadate-2.0 \
	--vapi vapi/valadate-2.0.vapi \
	-H include/valadate.h \
	-g

libvaladate_cli_2_0_la_LIBADD = \
	$(COVERAGE_LIBS) \
	-dlopen	$(VALADATELIB) \
	$(VALADATE_CLI_LIBS)

libvaladate_cli_2_0_la_LDFLAGS = \
	-version-info $(LT_CURRENT):$(LT_REVISION):$(LT_AGE) \
	-export-dynamic \
	-shared

# includes
libvaladate_cli_1_0includedir = \
	$(includedir)/valadate

libvaladate_cli_1_0include_HEADERS = \
	include/valadate.h

# Platform specific flags

if PLATFORM_WIN32
libvaladate_2_0_la_LDFLAGS += -no-undefined
libvaladate_cli_2_0_la_LDFLAGS += -no-undefined
endif

if NATIVE_WIN32
libvaladate_2_0_la_LDFLAGS += -export-dynamic
libvaladate_cli_2_0_la_LDFLAGS += -export-dynamic
endif

# vapis
vapidir = \
	$(datadir)/vala/vapi

dist_vapi_DATA = \
	vapi/libvaladate-2.0.vapi \
	vapi/libvaladate-2.0.deps \
	vapi/valadate-2.0.vapi \
	vapi/valadate-2.0.deps

# pkg-config
pkgconfigdir = \
	$(libdir)/pkgconfig

pkgconfig_DATA = \
	libvaladate-2.0.pc \
	valadate-2.0.pc


-include $(INTROSPECTION_MAKEFILE)
if HAVE_INTROSPECTION

libvaladate_dlname = \
	`$(SED) -nE "s/^dlname='([A-Za-z0-9.+-]+)'/\1/p" libvaladate-2.0.la`

Valadate-2.0.typelib: Valadate-2.0.gir
	g-ir-compiler \
		--shared-library=$(libvaladate_dlname) \
		--output=$@ \
		$<

girdir = $(datadir)/gir-1.0
gir_DATA = Valadate-2.0.gir

typelibdir = $(libdir)/girepository-1.0
typelib_DATA = Valadate-2.0.typelib

CLEANFILES += $(gir_DATA) $(typelib_DATA)
endif

# install gdb scripts
gdbdir = $(datadir)/valadate/gdb
dist_gdb_SCRIPTS = src/valadate_gdb.py

src/libvaladate-gdb.py: src/libvaladate-gdb.py.in
	$(AM_V_GEN) $(SED) -e "s|\@datadir\@|$(datadir)|" $(srcdir)/src/libvaladate-gdb.py.in > $(builddir)/src/libvaladate-gdb.py

install-data-hook: src/libvaladate-gdb.py
	mkdir -p $(DESTDIR)$(datadir)/gdb/auto-load/$(libdir)
	$(INSTALL) $(builddir)/src/libvaladate-gdb.py $(DESTDIR)$(datadir)/gdb/auto-load/$(libdir)/libvaladate-2.0.so.0.$(LT_CURRENT).$(LT_REVISION)-gdb.py

uninstall-gdb:
	-rm -r $(DESTDIR)$(datadir)/gdb

CLEANFILES += src/libvaladate-gdb.py

EXTRA_DIST = \
	libvaladate-2.0.pc.in \
	valadate-2.0.pc.in

MAINTAINERCLEANFILES = \
	vapi/libvaladate-2.0.vapi \
	vapi/valadate-2.0.vapi \
	include/libvaladate.h \
	include/valadate.h


.NOTPARALLEL: noinst_LTLIBRARIES

-include $(top_srcdir)/git.mk
