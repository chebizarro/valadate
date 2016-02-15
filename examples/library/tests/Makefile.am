#include $(top_builddir)/base.am

#DISTCHECK_CONFIGURE_FLAGS = --enable-introspection

include $(top_srcdir)/build/autotools/glib-tap.mk

test_programs = testlibrary-0

bad_sources = \
	LibraryPerfTest.vala \
	LibraryTests.vala \
	LibraryDBTest.vala \
	PerfTestSetup.vala \
	gui/AddBookViewTest.vala \
	gui/FindBookByTitleViewTest.vala \
	gui/BaseViewTestCase.vala \
	gui/LibraryFrameTest.vala \
	gui/FindBookByTitleTest.vala \
	gui/BookViewTest.vala \
	gui/AddBookTest.vala \
	gui/LibraryFrameViewTest.vala \
	xml/XMLElementTest.vala \
	xml/LibraryXMLDocTest.vala

testlibrary_0_SOURCES =  \
	BookTest.vala \
	MockLibraryDB.vala \
	LibraryDBTest.vala \
	LibraryTest.vala
	
testlibrary_0_VALAFLAGS = \
	$(LIBRARY_VALAFLAGS) \
	--pkg libvaladate-1.0 \
	--vapidir $(abs_builddir)/../../../libvaladate \
	--pkg liblibrary-1.0 \
	--vapidir $(top_srcdir)/src \
	--gir testlibrary-0.gir \
	--library testlibrary \
	--target-glib=2.40.0 \
	--pkg gio-2.0 \
	--pkg gee-0.8 \
	-g


testlibrary_0_LDFLAGS =  \
	-fPIE \
	-rdynamic

testlibrary_0_LDADD = \
	$(LIBRARY_LIBS) \
	$(abs_builddir)/../../../libvaladate/libvaladate.la \
	$(top_builddir)/src/liblibrary.la

testlibrary_0_CPPFLAGS = \
	$(LIBRARY_CPPFLAGS) \
	-DLIBRARY_TESTS_DIR=\""$(LIBRARY_TESTS_DIR)"\" \
	-fPIE
	
testlibrary_0_CFLAGS = $(LIBRARY_CFLAGS) \
	-I$(abs_builddir)/../../../libvaladate \
	-I$(top_builddir)/src \
	-shared \
	-pie


CLEANFILES += \
	$(testlibrary_0_SOURCES:.vala=.c) \
	*.stamp \
	*.vapi \
	*.o \
	*.gir \
	*.gcda \
	*.gcno


DISTCLEANFILES += $(CLEANFILES)

-include $(top_srcdir)/git.mk
