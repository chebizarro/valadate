include $(top_srcdir)/base.am

ACLOCAL_AMFLAGS  = -I build/autotools ${ACLOCAL_FLAGS}
AUTOMAKE_OPTIONS = subdir-objects

EXTRA_DIST = \
	$(noinst_DATA) \
	$(INTLTOOL_FILES) \
	autogen.sh

SUBDIRS = build libvaladate tests vapi

if ENABLE_EXAMPLES
SUBDIRS += examples
endif

if ENABLE_DOCS
SUBDIRS += docs
endif

-include $(top_srcdir)/git.mk
