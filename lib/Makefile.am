# --- libvaladate ---

noinst_LTLIBRARIES = libvaladate.la

libvaladate_la_SOURCES = \
	fixture.vala \
	tempdir.vala \
	wait.vala

libvaladate_la_CFLAGS = $(VALADATE_CFLAGS)

libvaladate_la_CPPLAGS = $(VALADATE_CPPFLAGS) \
	$(addprefix -I ,$(VALADATE_LIBS)) \
	`pkg-config --cflags --libs gio-2.0`

libvaladate_la_VALAFLAGS = \
	--library libvaladate-0.1 \
	--vapi libvaladate-0.1.vapi \
	-H libvaladate.h \
	--gir=Valadate-1.0.gir \
	--pkg gio-2.0 \
	--pkg glib-2.0 \
	--pkg posix \
	--target-glib=2.44.0 \
	-g

libvaladate_la_LIBADD = $(VALADATE_LIBS) \
	-lgio-2.0

CLEANFILES = $(libvaladate_SOURCES:.vala=.c) \
	libvaladate-0.1.vapi \
	libvaladate.h \
	Valadate-1.0.gir \
	*.stamp

MAINTAINERCLEANFILES = $(libvaladate_la_SOURCES:.vala=.c)
