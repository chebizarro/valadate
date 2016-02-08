include $(top_srcdir)/base.am

# --- libvaladate ---

noinst_LTLIBRARIES = libvaladate.la

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
	--library libvaladate-1.0 \
	--vapi libvaladate-1.0.vapi \
	-H libvaladate.h \
	--gir=Valadate-1.0.gir \
	--pkg gio-2.0 \
	--pkg glib-2.0 \
	--pkg posix \
	--target-glib=2.44.0 \
	-g

libvaladate_la_LIBADD = $(VALADATE_LIBS) \
	-lgio-2.0

CLEANFILES = $(libvaladate_la_SOURCES:.vala=.c) \
	libvaladate-1.0.vapi \
	libvaladate.h \
	Valadate-1.0.gir \
	*.stamp

DISTCLEANFILES = $(CLEANFILES)

MAINTAINERCLEANFILES = $(libvaladate_la_SOURCES:.vala=.c)

-include $(top_srcdir)/git.mk
