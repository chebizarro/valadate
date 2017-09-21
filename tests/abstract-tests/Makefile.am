include $(top_srcdir)/base.am
include $(top_srcdir)/build/autotools/glib-tap.mk

TESTS_ENVIRONMENT += \
	G_MESSAGES_DEBUG=all \
	G_SLICE=debug-blocks

test_programs = tests-abstract-tests-0

tests_abstract_tests_0_SOURCES =  \
	object-factory.vala \
	abstract-tests.vala \
	concrete-tests.vala 
	
tests_abstract_tests_0_VALAFLAGS = \
	--pkg gmodule-2.0 \
	--gir tests-abstract-tests-0.gir \
	--library tests-abstract-tests-0 \
	$(TESTS_VALAFLAGS)

tests_abstract_tests_0_LDADD = \
	$(TESTS_LIBS) \
	$(VALADATELIB) \
	$(TEST_RUNNER)

tests_abstract_tests_0_CPPFLAGS = \
	$(TESTS_CPPFLAGS)
	
tests_abstract_tests_0_CFLAGS = \
	$(TESTS_CFLAGS)

if NATIVE_WIN32
tests_abstract_tests_0_CFLAGS += \
	-Wl,--export-all-symbols
else
tests_abstract_tests_0_CFLAGS += \
	-pie
tests_abstract_tests_0_CPPFLAGS += \
	-fPIE
endif


CLEANFILES += \
	*.vapi \
	*.gir

-include $(top_srcdir)/git.mk
