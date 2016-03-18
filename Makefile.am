include $(top_srcdir)/base.am

ACLOCAL_AMFLAGS  = -I build/autotools ${ACLOCAL_FLAGS}
AUTOMAKE_OPTIONS = subdir-objects

EXTRA_DIST = \
	$(noinst_DATA) \
	$(INTLTOOL_FILES) \
	autogen.sh

SUBDIRS = build libvaladate tests vapi

DIST_SUBDIRS = $(SUBDIRS)

-include $(top_srcdir)/git.mk
