#include $(top_srcdir)/../../base.am
include $(top_srcdir)/build-aux/glib-tap.mk

ACLOCAL_AMFLAGS  = -I build-aux ${ACLOCAL_FLAGS}
AUTOMAKE_OPTIONS = subdir-objects

#SUBDIRS = . tests 

bin_PROGRAMS = src/exampleapp

src_exampleapp_SOURCES =			\
	src/application.vala			\
	src/application-preferences.vala	\
	src/application-window.vala		\
	src/main.vala				\
	src/resources.c				\
	$(NULL)

src_exampleapp_VALAFLAGS =			\
	--target-glib=2.38			\
	@EXAMPLE_PACKAGES@			\
	--gresources $(gresource_file)		\
	$(NULL)

src_exampleapp_CFLAGS =				\
	@EXAMPLE_CFLAGS@			\
	-w					\
	$(NULL)

src_exampleapp_LDADD =				\
	@EXAMPLE_LIBS@				\
	$(NULL)

gresource_file = $(top_srcdir)/data/exampleapp.gresource.xml
resource_files = 				\
	$(top_srcdir)/data/app-menu.ui		\
	$(top_srcdir)/data/gears-menu.ui	\
	$(top_srcdir)/data/prefs.ui		\
	$(top_srcdir)/data/window.ui		\
	$(NULL)

src/resources.c: $(gresource_file) $(resource_files)
	$(AM_V_GEN) $(GLIB_COMPILE_RESOURCES) 	\
		--target=$@			\
		--sourcedir=$(top_srcdir)/data	\
		--generate-source $<

schema_file = $(top_srcdir)/data/org.gtk.exampleapp.gschema.xml

gsettings_SCHEMAS =				\
	$(schema_file)				\
	$(NULL)

@GSETTINGS_RULES@

data/gschemas.compiled: $(schema_file)
	$(GLIB_COMPILE_SCHEMAS) $(top_srcdir)/data

data_desktopdir = $(datadir)/applications
data_desktop_DATA = data/exampleapp.desktop

data/exampleapp.desktop: data/exampleapp.desktop.in
	$(AM_V_GEN) [ -d $(@D) ] || $(mkdir_p) $(@D) ; \
		sed -e "s|\@bindir\@|$(bindir)|g" $< > $@

data_iconsdir = $(datadir)/icons/hicolor/48x48/apps
data_icons_DATA = data/exampleapp.png

noinst_DATA +=					\
	$(gresource_file)			\
	$(resource_files)			\
	$(NULL)

docs_files =					\
	docs/vala-example.css			\
	docs/vala.xml				\
	$(NULL)

docs_js =					\
	docs/jquery.js				\
	docs/jquery.syntax.brush.csharp.js	\
	docs/jquery.syntax.brush.css.js		\
	docs/jquery.syntax.brush.html.js	\
	docs/jquery.syntax.brush.javascript.js	\
	docs/jquery.syntax.brush.php-script.js	\
	docs/jquery.syntax.brush.ruby.js	\
	docs/jquery.syntax.brush.xml.js		\
	docs/jquery.syntax.core.js		\
	docs/jquery.syntax.js			\
	docs/jquery.syntax.layout.yelp.js	\
	docs/yelp.js				\
	$(NULL)

docs_images =					\
	docs/images/exampleapp1.png		\
	docs/images/exampleapp2.png		\
	docs/images/exampleapp3.png		\
	docs/images/exampleapp4.png		\
	docs/images/exampleapp5.png		\
	docs/images/exampleapp6.png		\
	docs/images/exampleapp7.png		\
	docs/images/exampleapp8.png		\
	docs/images/exampleapp9.png		\
	$(NULL)

EXTRA_DIST +=					\
	data/exampleapp.desktop.in		\
	data/exampleapp.gresource.xml		\
	docs/vala.xml				\
	util/valadocize				\
	$(resource_files)			\
	$(schema_file)				\
	$(data_icons_DATA)			\
	$(docs_files)				\
	$(docs_js)				\
	$(docs_images)				\
	$(NULL)

DISTCLEANFILES +=				\
	$(data_desktop_DATA)			\
	$(NULL)

if DOCS
docs/index.page: docs/vala.xml
	$(top_srcdir)/util/valadocize $< $@

docs/index.html: docs/index.page
	$(YELP_BUILD) html -o docs $< ;\
	sed -i -e "s/C\.css/vala-example.css/g" $@


CLEANFILES +=					\
	docs/index.html				\
	docs/index.page				\
	docs/C.css				\
	$(NULL)
endif


test_programs = tests/test_example

tests_test_example_SOURCES =  \
	tests/example.vala
	
tests_test_example_VALAFLAGS = \
	--pkg libvaladate-1.0 \
	--vapidir $(abs_builddir)/../../libvaladate \
	--gir test_example-0.gir \
	--library test_example \
	--shared-library test_example \
	--target-glib=2.40.0 \
	--pkg gio-2.0 \
	-g

tests_test_example_LDFLAGS =  \
	-fPIE \
	-rdynamic

tests_test_example_LDADD = \
	$(EXAMPLE_LIBS) \
	$(abs_builddir)/../../libvaladate/libvaladate.la \
	-lgio-2.0

tests_test_example_CPPFLAGS = \
	$(EXAMPLE_CPPFLAGS) \
	-fPIE
	
tests_test_example_CFLAGS = $(EXAMPLE_CFLAGS) \
	-I$(abs_builddir)/../../libvaladate \
	-pie \
	-fPIE \
	-shared

CLEANFILES += \
	$(tests_test_example_SOURCES:.vala=.c) \
	*.stamp \
	*.vapi \
	*.o \
	*.gir \
	*.gcda \
	*.gcno


DISTCLEANFILES += $(CLEANFILES)


-include $(top_srcdir)/git.mk
