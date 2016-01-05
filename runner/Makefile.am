# --- valadate application ---

bin_PROGRAMS = valadate
	
valadate_sources = \
	girreader.vala \
	girsuiteinfo.vala \
	runner.vala \
	suiteinfo.vala \
	testinfo.vala \
	vapireader.vala \
	vapisuiteinfo.vala \
	vapitestgatherer.vala	

valadate_SOURCES = $(valadate_sources) \
	$(top_builddir)/lib/libvaladate-0.1.vapi

valadate_VALAFLAGS = \
	--pkg gio-2.0 \
	--pkg glib-2.0 \
	--pkg posix \
	--pkg gobject-introspection-1.0 \
	--pkg gmodule-2.0 \
	--pkg libvala-0.30 \
	--target-glib=2.44.0 \
	--vapidir $(top_builddir)/lib \
	--vapidir $(top_builddir)/vapi

valadate_CFLAGS = \
	$(VALADATE_CFLAGS) \
	-I$(top_srcdir)/lib \
	-I$(top_srcdir)/vapi

valadate_CPPFLAGS = $(VALADATE_CPPFLAGS) \
	$(addprefix -I ,$(VALADATE_LIBS)) \
	`pkg-config --cflags --libs $(pkg_modules)`

valadate_LDADD = \
	$(VALADATE_LIBS) \
	$(top_builddir)/lib/libvaladate.la

CLEANFILES = \
	$(valadate_SOURCES:.vala=.c) \
	$(BUILT_SOURCES)

MAINTAINERCLEANFILES = \
	$(valadate_SOURCES:.vala=.c)  \
	$(BUILT_SOURCES)
