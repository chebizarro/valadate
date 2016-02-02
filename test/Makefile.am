# --- test tes application ---

noinst_LTLIBRARIES = libtest.la
	
libtest_la_sources = \
	async.vala \
	prime.vala \
	tempdir.vala \
	wait.vala

libtest_la_SOURCES = $(libtest_la_sources)

libtest_la_VALAFLAGS = \
	--library libtest.0 \
	--gir=Test-0.gir \
	--pkg glib-2.0 \
	--pkg gio-2.0 \
	--pkg gobject-2.0 \
	--pkg libvala-0.30 \
	--pkg libvaladate-0.1 \
	--target-glib=2.44.0 \
	--vapidir $(top_builddir)/lib

libtest_la_CFLAGS = \
	$(VALADATE_CFLAGS) \
	-I$(top_srcdir)/lib

libtest_la_CPPFLAGS = $(VALADATE_CPPFLAGS) \
	$(addprefix -I ,$(VALADATE_LIBS)) \
	`pkg-config --cflags --libs $(pkg_modules)`

libtest_la_LIBADD = \
	$(VALADATE_LIBS) 

CLEANFILES = \
	$(libtest_la_SOURCES:.vala=.c) \
	*.stamp

MAINTAINERCLEANFILES = \
	$(libtest_la_SOURCES:.vala=.c)
