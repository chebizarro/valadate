include $(top_srcdir)/base.am
include $(top_srcdir)/libvaladate/libvaladate.am

SUBDIRS = . drivers

lib_LTLIBRARIES = libvaladate-2.0.la libvaladate-cli-2.0.la

# The main valadate library which contains the framework and utilities

libvaladate_2_0_la_SOURCES = \
	$(libvaladate_sources)

libvaladate_2_0_la_CFLAGS = \
	-DVALADATE_DRIVER_DIR=\""$(VALADATE_DRIVER_DIR)"\" \
	$(VALADATE_CFLAGS) \
	-g -Og
	
libvaladate_2_0_la_CPPLAGS = \
	-fPIE \
	$(VALADATE_CPPFLAGS)

libvaladate_2_0_la_VALAFLAGS = \
	--library libvaladate \
	--vapi vapi/libvaladate-2.0.vapi \
	-H include/libvaladate.h \
	--gir=Valadate-2.0.gir \
	$(VALADATE_VALAFLAGS)

libvaladate_2_0_la_LDFLAGS = \
	-export-dynamic \
	-shared
	
libvaladate_2_0_la_LIBADD = \
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
	-I$(top_srcdir)/libvaladate/include \
	-g -Og \
	$(VALADATE_CLI_CFLAGS)

libvaladate_cli_2_0_la_CPPLAGS = \
	$(VALADATE_CLI_CPPFLAGS)

libvaladate_cli_2_0_la_VALAFLAGS = \
	--pkg libvaladate-2.0 \
	--vapidir $(top_builddir)/libvaladate/vapi \
	--vapidir $(top_builddir)/vapi \
	--library valadate-2.0 \
	--vapi vapi/valadate-2.0.vapi \
	-H include/valadate.h \
	-g \
	$(VALADATE_CLI_VALAFLAGS)

libvaladate_cli_2_0_la_LIBADD = \
	-dlopen	$(VALADATELIB) \
	$(VALADATE_CLI_LIBS)

libvaladate_cli_2_0_la_LDFLAGS = \
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

Valadate-2.0.typelib: Valadate-2.0.gir
	g-ir-compiler \
		--shared-library=libvaladate.so \
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
dist_gdb_SCRIPTS = valadate_gdb.py

libvaladate-gdb.py: libvaladate-gdb.py.in
	$(AM_V_GEN) $(SED) -e "s|\@datadir\@|$(datadir)|" $(srcdir)/src/libvaladate-gdb.py.in > $(builddir)/src/libvaladate-gdb.py

if HAVE_GLIB_RUNTIME_LIBDIR
ABS_GLIB_RUNTIME_LIBDIR = $(realpath $(libdir)/$(GLIB_RUNTIME_LIBDIR))
else
ABS_GLIB_RUNTIME_LIBDIR = $(libdir)
endif

install-data-hook: libvaladate-gdb.py
	mkdir -p $(DESTDIR)$(datadir)/gdb/auto-load$(ABS_GLIB_RUNTIME_LIBDIR)
	$(INSTALL) $(builddir)/src/libvaladate-gdb.py $(DESTDIR)$(datadir)/gdb/auto-load$(ABS_GLIB_RUNTIME_LIBDIR)/libvaladate-2.0.so.0.$(LT_CURRENT).$(LT_REVISION)-gdb.py
if HAVE_GLIB_RUNTIME_LIBDIR
	mkdir -p $(DESTDIR)$(libdir)/$(GLIB_RUNTIME_LIBDIR)
	mv $(DESTDIR)$(libdir)/libvaladate-2.0.so.0 $(DESTDIR)$(libdir)/$(GLIB_RUNTIME_LIBDIR)
	mv $(DESTDIR)$(libdir)/libvaladate-2.0.so.0.$(LT_CURRENT).$(LT_REVISION) $(DESTDIR)$(libdir)/$(GLIB_RUNTIME_LIBDIR)
	rm -f $(DESTDIR)$(libdir)/libvaladate-2.0.so
	ln -s $(GLIB_RUNTIME_LIBDIR)/libvaladate-2.0.so.0.$(LT_CURRENT).$(LT_REVISION) $(DESTDIR)$(libdir)/libvaladate-2.0.so
endif

uninstall-gdb:
	-rm -r $(DESTDIR)$(datadir)/gdb

EXTRA_DIST = \
	libvaladate-2.0.pc.in \
	valadate-2.0.pc.in


.NOTPARALLEL: noinst_LTLIBRARIES

-include $(top_srcdir)/git.mk
