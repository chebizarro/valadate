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
	--library tests-abstract-tests \
	$(TESTS_VALAFLAGS)

tests_abstract_tests_0_LDADD = \
	$(TESTS_LIBS) \
	$(VALADATELIB) \
	$(TEST_RUNNER)

tests_abstract_tests_0_CPPFLAGS = \
	$(TESTS_CPPFLAGS) \
	-fPIE
	
tests_abstract_tests_0_CFLAGS = \
	$(TESTS_CFLAGS) \
	-pie

-include $(top_srcdir)/git.mk
