# --- tests ---

noinst_PROGRAMS = tests_libvaladate

TEST_PROGS = tests_libvaladate
check_PROGRAMS = tests_libvaladate

tests_libvaladate_SOURCES =  \
	libvaladate/main.vala
	
tests_libvaladate_VALAFLAGS = \
	$(VALADATE_VALAFLAGS) \
	--pkg libvaladate-1.0 \
	--vapidir $(top_builddir)/libvaladate \
	-g

tests_libvaladate_LDADD = \
	$(VALADATE_LIBS) \
	$(top_builddir)/libvaladate/libvaladate.la

tests_libvaladate_CPPFLAGS = \
	$(VALADATE_CPPFLAGS)
	
tests_libvaladate_CFLAGS = $(VALADATE_CFLAGS) \
	-I$(top_srcdir)/libvaladate

CLEANFILES = $(tests_libvaladate_tests_libvaladate_SOURCES:.vala=.c)

DISTCLEANFILES = $(CLEANFILES)

