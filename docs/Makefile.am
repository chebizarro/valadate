include $(top_srcdir)/base.am
include $(top_srcdir)/libvaladate/libvaladate.am

#man_MANS = valadate.1
#EXTRA_DIST = valadate.1

if ENABLE_VALADOC

VALADOC_FLAGS = --force \
		--pkg gio-2.0 \
		--pkg glib-2.0 \
		--pkg libxml-2.0 \
		--pkg gmodule-2.0 \
		--pkg json-glib-1.0 \
		--pkg libxslt \
		--pkg posix \
		--vapidir $(top_srcdir)/vapi \
		--package-name Valadate \
		--package-version $(VERSION) \
		--target-glib=2.40.0 \
		$(addprefix $(top_srcdir)/libvaladate/,$(libvaladate_sources))

valadoc:
	$(VALADOC) \
		-o valadoc \
		$(VALADOC_FLAGS)

devhelp:
	$(VALADOC) \
		-o devhelp \
		--doclet devhelp \
		$(VALADOC_FLAGS)

gtkdoc:
	$(VALADOC) \
		-X $(top_srcdir)/libvaladate/libvaladate-1.0.h \
		-X $(top_srcdir)/config.h \
		-X -l -X $(top_srcdir)/libvaladate/.libs/libvaladate-1.0.so \
		-o gtkdoc \
		--doclet gtkdoc \
		$(VALADOC_FLAGS)

clean-local:
	rm -rf valadoc devhelp gtkdoc

uninstall-hook:
	rm -rf $(DESTDIR)$(datadir)/devhelp/books/Valadate
	rm -rf $(DESTDIR)$(datadir)/gtk-doc/html/Valadate

install-data-hook: devhelp gtkdoc
	$(MKDIR_P) $(DESTDIR)$(datadir)/devhelp/books/Valadate/img
	$(INSTALL_DATA) -t $(DESTDIR)$(datadir)/devhelp/books/Valadate devhelp/Valadate/*.*
	$(INSTALL_DATA) -t $(DESTDIR)$(datadir)/devhelp/books/Valadate/img devhelp/Valadate/img/*
	$(MKDIR_P) $(DESTDIR)$(datadir)/gtk-doc/html/Valadate
	cp -R gtkdoc/html $(DESTDIR)$(datadir)/gtk-doc/html/Valadate

html: valadoc devhelp gtkdoc

endif

-include $(top_srcdir)/git.mk
