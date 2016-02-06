# --- PIE tests ---

noinst_PROGRAMS = tests_PIE

TEST_PROGS = tests_PIE
check_PROGRAMS = tests_PIE

tests_PIE_SOURCES =  \
	testpie.vala
	
tests_PIE_VALAFLAGS = \
	$(VALADATE_VALAFLAGS) \
	--pkg libvaladate-1.0 \
	--vapidir $(top_builddir)/libvaladate \
	--library testpie \
	--shared-library testpie \
	--target-glib=2.40.0 \
	-g

tests_PIE_LDFLAGS =  \
	-fPIE

tests_PIE_LDADD = \
	$(VALADATE_LIBS) \
	$(top_builddir)/libvaladate/libvaladate.la

tests_PIE_CPPFLAGS = \
	$(VALADATE_CPPFLAGS)
	
tests_PIE_CFLAGS = $(VALADATE_CFLAGS) \
	-I$(top_srcdir)/libvaladate

CLEANFILES = \
	$(tests_PIE_SOURCES:.vala=.c) \
	*.stamp \
	*.vapi \
	*.o

DISTCLEANFILES = $(CLEANFILES)

-include $(top_srcdir)/git.mk
