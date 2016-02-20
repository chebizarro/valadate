include $(top_srcdir)/base.am
include $(top_srcdir)/build/autotools/glib-tap.mk

test_programs = tests_libvaladate_utils

tests_libvaladate_utils_SOURCES =  \
	testsignalwaiter.vala \
	testtempdir.vala \
	testasync.vala \
	wait.vala \
	main.vala
	
tests_libvaladate_utils_VALAFLAGS = \
	$(TESTS_VALAFLAGS)

tests_libvaladate_utils_LDADD = \
	$(TESTS_LIBS)

tests_libvaladate_utils_CPPFLAGS = \
	$(TESTS_CPPFLAGS)
	
tests_libvaladate_utils_CFLAGS = \
	$(TESTS_CFLAGS)

CLEANFILES += \
	$(tests_libvaladate_utils_SOURCES:.vala=.c) \
	*.stamp \
	*.html \
	*.xml \
	*.gcda \
	*.gcno

DISTCLEANFILES += $(CLEANFILES)

-include $(top_srcdir)/git.mk
