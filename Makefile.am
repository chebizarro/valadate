include $(top_srcdir)/base.am

ACLOCAL_AMFLAGS  = -I build/autotools ${ACLOCAL_FLAGS}
AUTOMAKE_OPTIONS = subdir-objects

EXTRA_DIST = \
	$(noinst_DATA) \
	$(INTLTOOL_FILES) \
	autogen.sh

SUBDIRS = build libvaladate tests vapi

DIST_SUBDIRS = $(SUBDIRS)

if ENABLE_EXAMPLES
SUBDIRS += examples
DIST_SUBDIRS = $(SUBDIRS)
endif

if ENABLE_DOCS
SUBDIRS += docs
DIST_SUBDIRS = $(SUBDIRS)
endif

-include $(top_srcdir)/git.mk
