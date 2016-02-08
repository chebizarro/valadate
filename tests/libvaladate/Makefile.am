include $(top_srcdir)/base.am
include $(top_srcdir)/build/autotools/glib-tap.mk

test_programs = tests_libvaladate

log_file = $(VALADATE_TESTS_DIR)/results/ # Where to save the result and output of the test script.
trs_file = $(VALADATE_TESTS_DIR)/results/ # Where to save the metadata of the test run.


tests_libvaladate_SOURCES =  \
	main.vala \
	test_tempdir.vala
	
tests_libvaladate_VALAFLAGS = \
	$(VALADATE_VALAFLAGS) \
	--pkg libvaladate-1.0 \
	--vapidir $(top_builddir)/libvaladate \
	--pkg config \
	--vapidir $(top_builddir)/vapi \
	--pkg gio-2.0 \
	-g

tests_libvaladate_LDADD = \
	$(VALADATE_LIBS) \
	$(top_builddir)/libvaladate/libvaladate.la

tests_libvaladate_CPPFLAGS = \
	$(VALADATE_CPPFLAGS)
	
tests_libvaladate_CFLAGS = $(VALADATE_CFLAGS) \
	-I$(top_srcdir)/libvaladate \
	-DVALADATE_TESTS_DIR=\""$(VALADATE_TESTS_DIR)"\"

CLEANFILES += \
	$(tests_libvaladate_SOURCES:.vala=.c) \
	*.stamp \
	*.html \
	*.xml

DISTCLEANFILES += $(CLEANFILES)



-include $(top_srcdir)/git.mk
