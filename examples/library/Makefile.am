#include $(top_builddir)/base.am

ACLOCAL_AMFLAGS  = -I build/autotools ${ACLOCAL_FLAGS}
AUTOMAKE_OPTIONS = subdir-objects

CLEANFILES = *.stamp

SUBDIRS = src tests build

-include $(top_srcdir)/git.mk
