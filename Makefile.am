ACLOCAL_AMFLAGS  = -I m4 ${ACLOCAL_FLAGS}
AUTOMAKE_OPTIONS = subdir-objects

EXTRA_DIST = \
	$(noinst_DATA) \
	$(INTLTOOL_FILES) \
	autogen.sh

CLEANFILES = *.stamp

SUBDIRS = libvaladate tests vapi

-include $(top_srcdir)/git.mk
