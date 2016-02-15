include $(top_srcdir)/base.am
include $(top_srcdir)/build/autotools/glib-tap.mk

test_programs = tests_libvaladate_utils

tests_libvaladate_utils_SOURCES =  \
	testsignalwaiter.vala \
	testtempdir.vala \
	testasync.vala \
	main.vala
	
tests_libvaladate_utils_VALAFLAGS = \
	$(VALADATE_VALAFLAGS) \
	--pkg libvaladate-1.0 \
	--vapidir $(top_builddir)/libvaladate \
	--pkg config \
	--vapidir $(top_builddir)/vapi \
	--pkg gio-2.0 \
	-g

tests_libvaladate_utils_LDADD = \
	$(VALADATE_LIBS) \
	$(top_builddir)/libvaladate/libvaladate.la \
	-lgio-2.0


tests_libvaladate_utils_CPPFLAGS = \
	$(VALADATE_CPPFLAGS)
	
tests_libvaladate_utils_CFLAGS = $(VALADATE_CFLAGS) \
	-I$(top_srcdir)/libvaladate \
	-DVALADATE_TESTS_DIR=\""$(VALADATE_TESTS_DIR)"\"

CLEANFILES += \
	$(tests_libvaladate_utils_SOURCES:.vala=.c) \
	*.stamp \
	*.html \
	*.xml \
	*.gcda \
	*.gcno

DISTCLEANFILES += $(CLEANFILES)

-include $(top_srcdir)/git.mk
