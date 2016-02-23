include $(top_srcdir)/base.am
include $(top_srcdir)/build/autotools/glib-tap.mk

# --- Test exe ---
test_programs = testgenie-0

testgenie.c: testgenie.gs
	$(VALAC) -C $< $(testgenie_0_VALAFLAGS)

testgenie_0_SOURCES = testgenie.c
	
testgenie_0_VALAFLAGS = \
	$(TESTS_VALAFLAGS) \
	--gir testgenie-0.gir \
	--library testgenie

testgenie_0_LDFLAGS =  \
	-fPIE

testgenie_0_LDADD = \
	$(TESTS_LIBS)
	
testgenie_0_CPPFLAGS = \
	$(TESTS_CPPFLAGS) \
	-fPIE
	
testgenie_0_CFLAGS = \
	$(TESTS_CFLAGS) \
	-pie
	
CLEANFILES += \
	$(testgenie_0_SOURCES:.gs=.c) \
	*.stamp \
	*.o \
	*.gir \
	*.gcda \
	*.gcno \
	*.vapi

DISTCLEANFILES += $(CLEANFILES)

-include $(top_srcdir)/git.mk
