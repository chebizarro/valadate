#include $(top_srcdir)/base.am

noinst_LTLIBRARIES = liblibrary.la

liblibrary_la_SOURCES = \
	Book.vala \
	LibraryDB.vala \
	Library.vala \
	xml/LibraryXMLDoc.vala \
	xml/XMLElement.vala

liblibrary_la_CFLAGS = $(LIBRARY_CFLAGS)

liblibrary_la_CPPLAGS = $(LIBRARY_CPPFLAGS) \
	$(addprefix -I ,$(LIBRARY_LIBS)) \
	`pkg-config --cflags`

liblibrary_la_VALAFLAGS = \
	--shared-library liblibrary-1.0 \
	--library liblibrary-1.0 \
	--vapi liblibrary-1.0.vapi \
	-H liblibrary.h \
	--pkg gee-0.8 \
	--target-glib=2.44.0 \
	-g

liblibrary_la_LIBADD = $(LIBRARY_LIBS)

bin_PROGRAMS = library

bad_sources = \
	gui/FindBookByTitle.vala \
	gui/FindBookByTitleView.vala \
	gui/AddBook.vala \
	gui/LibraryFrameView.vala \
	gui/AddBookView.vala \
	gui/BaseView.vala \
	gui/BookView.vala \
	gui/LibraryFrame.vala

library_SOURCES = \
	LibraryApp.vala

library_VALAFLAGS = \
	--pkg gee-0.8 \
	$(LIBRARY_VALAFLAGS)

library_CFLAGS = $(LIBRARY_CFLAGS)

library_CPPFLAGS = $(LIBRARY_CPPFLAGS)

library_LDADD = $(LIBRARY_LIBS)

CLEANFILES = \
	$(library_SOURCES:.vala=.c) \
	$(liblibrary_la_SOURCES:.vala=.c) \
	*.vapi \
	*.h \
	*.gcda \
	*.gcno \
	*.stamp
	

DISTCLEANFILES = $(CLEANFILES)

MAINTAINERCLEANFILES = $(CLEANFILES)

-include $(top_srcdir)/git.mk
