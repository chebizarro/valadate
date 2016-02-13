#include $(top_srcdir)/base.am

lib_LTLIBRARIES = liblibrary.la

liblibrary_la_SOURCES = \
	Book.vala \
	Library.vala


liblibrary_la_CFLAGS = $(LIBRARY_CFLAGS)

liblibrary_la_CPPLAGS = $(LIBRARY_CPPFLAGS) \
	$(addprefix -I ,$(LIBRARY_LIBS))

liblibrary_la_VALAFLAGS = \
	--library liblibrary-1.0 \
	--vapi liblibrary-1.0.vapi \
	-H liblibrary.h \
	--pkg gee-0.8 \
	--target-glib=2.44.0 \
	-g

liblibrary_la_LIBADD = $(LIBRARY_LIBS)

bin_PROGRAMS = library

bad_sources = \
	Book.vala \
	LibraryDB.vala \
	Library.vala \
	gui/FindBookByTitle.vala \
	gui/FindBookByTitleView.vala \
	gui/AddBook.vala \
	gui/LibraryFrameView.vala \
	gui/AddBookView.vala \
	gui/BaseView.vala \
	gui/BookView.vala \
	gui/LibraryFrame.vala \
	xml/LibraryXMLDoc.vala \
	xml/XMLElement.vala

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
