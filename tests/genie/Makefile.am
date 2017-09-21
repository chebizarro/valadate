include $(top_srcdir)/base.am
include $(top_srcdir)/build/autotools/glib-tap.mk

# --- Test exe ---
test_programs = testgenie-0

testgenie.c: testgenie.gs
	$(VALAC) -C $< $(testgenie_0_VALAFLAGS)

testgenie_0_SOURCES = testgenie.c
	
testgenie_0_VALAFLAGS = \
	$(TESTS_VALAFLAGS) \
	--vapidir $(top_srcdir)/libvaladate \
	--vapidir $(top_srcdir)/vapi \
	--gir testgenie-0.gir \
	--library testgenie-0

testgenie_0_LDADD = \
	$(TESTS_LIBS) \
	$(VALADATELIB) \
	$(TEST_RUNNER)
	
testgenie_0_CPPFLAGS = \
	$(TESTS_CPPFLAGS)
	
testgenie_0_CFLAGS = \
	$(TESTS_CFLAGS)

if NATIVE_WIN32
testgenie_0_CFLAGS += \
	-Wl,--export-all-symbols
else
testgenie_0_CFLAGS += \
	-pie
testgenie_0_CPPFLAGS += \
	-fPIE
endif

MAINTAINERCLEANFILES += \
	testgenie.c \
	*.vapi \
	*.gir

-include $(top_srcdir)/git.mk
