include $(top_srcdir)/base.am

# --- libvaladate ---

lib_LTLIBRARIES = libvaladate.la

libvaladate_la_SOURCES = \
	assert.vala \
	test.vala \
	testcase.vala \
	testfixture.vala \
	testsuite.vala \
	testresult.vala \
	testrunner.vala \
	tempdir.vala \
	wait.vala

libvaladate_la_CFLAGS = $(VALADATE_CFLAGS)

libvaladate_la_CPPLAGS = $(VALADATE_CPPFLAGS) \
	$(addprefix -I ,$(VALADATE_LIBS)) \
	`pkg-config --cflags --libs gio-2.0`

libvaladate_la_VALAFLAGS = \
	--shared-library libvaladate-1.0 \
	--library libvaladate-1.0 \
	--vapi libvaladate-1.0.vapi \
	-H libvaladate.h \
	--gir=Valadate-1.0.gir \
	--pkg gio-2.0 \
	--pkg glib-2.0 \
	--pkg posix \
	--target-glib=2.40.0 \
	-g

libvaladate_la_LIBADD = $(VALADATE_LIBS) \
	-lgio-2.0

# --- librunner ---

lib_LTLIBRARIES += librunner.la

librunner_la_SOURCES = \
	runner.vala

librunner_la_CFLAGS = $(VALADATE_CFLAGS) \
	-fPIE

librunner_la_CPPLAGS = $(VALADATE_CPPFLAGS) \
	$(addprefix -I ,$(VALADATE_LIBS)) \
	`pkg-config --cflags --libs gio-2.0`

librunner_la_VALAFLAGS = \
	--library librunner-1.0 \
	--vapi librunner-1.0.vapi \
	-H librunner.h \
	--gir=Runner-1.0.gir \
	--pkg gio-2.0 \
	--pkg glib-2.0 \
	--pkg gmodule-2.0 \
	--pkg libxml-2.0 \
	--pkg libvaladate-1.0 \
	--vapidir $(top_builddir)/libvaladate \
	--target-glib=2.40.0 \
	-g

librunner_la_LDFLAGS =  \
	-fPIE

librunner_la_LIBADD = $(VALADATE_LIBS) \
	$(top_builddir)/libvaladate/libvaladate.la \
	-lgio-2.0

CLEANFILES = \
	$(libvaladate_la_SOURCES:.vala=.c) \
	$(librunner_la_SOURCES:.vala=.c) \
	*.vapi \
	*.h \
	*.gir \
	*.stamp

DISTCLEANFILES = $(CLEANFILES)

MAINTAINERCLEANFILES = $(libvaladate_la_SOURCES:.vala=.c)

-include $(top_srcdir)/git.mk
