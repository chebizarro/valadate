#include $(top_builddir)/base.am

#DISTCHECK_CONFIGURE_FLAGS = --enable-introspection

include $(top_srcdir)/build/autotools/glib-tap.mk

test_programs = test_library

bad_sources = \
	LibraryTest.vala \
	LibraryPerfTest.vala \
	MockLibraryDB.vala \
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

test_library_SOURCES =  \
	BookTest.vala \
	LibraryTest.vala
	
test_library_VALAFLAGS = \
	--pkg libvaladate-1.0 \
	--pkg liblibrary-1.0 \
	--vapidir $(abs_builddir)/../../../libvaladate \
	--vapidir $(top_builddir)/src \
	--gir test_library-0.gir \
	--library test_library \
	-h test_library.h \
	--shared-library test_library \
	--target-glib=2.40.0 \
	--pkg gio-2.0 \
	--pkg gee-0.8 \
	-g

test_library_LDFLAGS =  \
	-fPIE \
	-rdynamic

test_library_LDADD = \
	$(LIBRARY_LIBS) \
	$(abs_builddir)/../../../libvaladate/libvaladate.la \
	$(top_builddir)/src/liblibrary.la \
	-lgio-2.0

test_library_CPPFLAGS = \
	$(LIBRARY_CPPFLAGS) \
	-fPIE
	
test_library_CFLAGS = $(LIBRARY_CFLAGS) \
	-I$(abs_builddir)/../../../libvaladate \
	-I$(top_builddir)/src \
	-pie \
	-fPIE \
	-shared


CLEANFILES += \
	$(test_library_SOURCES:.vala=.c) \
	*.stamp \
	*.vapi \
	*.o \
	*.gir \
	*.gcda \
	*.gcno


DISTCLEANFILES += $(CLEANFILES)

-include $(top_srcdir)/git.mk
