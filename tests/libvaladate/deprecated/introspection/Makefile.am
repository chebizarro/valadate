include $(top_srcdir)/base.am
include $(top_srcdir)/build/autotools/glib-tap.mk

test_programs = tests_libvaladate_introspection

tests_libvaladate_introspection_SOURCES =  \
	testinstrospection.vala \
	main.vala
	
tests_libvaladate_introspection_VALAFLAGS = \
	$(TESTS_VALAFLAGS) \
	--pkg json-glib-1.0 \
	--pkg libxml-2.0 \
	--pkg libxslt \
	-g

tests_libvaladate_introspection_LDADD = \
	$(TESTS_LIBS) \
	$(VALADATELIB)

tests_libvaladate_introspection_CPPFLAGS = \
	$(TESTS_CPPFLAGS)
	
tests_libvaladate_introspection_CFLAGS = \
	$(TESTS_CFLAGS)

CLEANFILES += \
	$(tests_libvaladate_introspection_SOURCES:.vala=.c)

DISTCLEANFILES += $(CLEANFILES)

-include $(top_srcdir)/git.mk
