include $(top_srcdir)/base.am

ACLOCAL_AMFLAGS  = -I build/autotools ${ACLOCAL_FLAGS}
AUTOMAKE_OPTIONS = subdir-objects

DISTCHECK_CONFIGURE_FLAGS = --enable-introspection

EXTRA_DIST = \
	$(noinst_DATA) \
	autogen.sh \
	vapi

SUBDIRS = build libvaladate tests vapi

if ENABLE_DOCS
SUBDIRS += docs
endif

MAINTAINERCLEANFILES = \
	$(srcdir)/build/aclocal.m4 \
	$(srcdir)/build/compile \
	$(srcdir)/build/config.guess \
	$(srcdir)/build/config.h.in \
	$(srcdir)/build/config.rpath \
	$(srcdir)/build/config.sub \
	$(srcdir)/build/depcomp \
	$(srcdir)/build/install-sh \
	$(srcdir)/build/ltmain.sh \
	$(srcdir)/build/missing \
	$(srcdir)/build/mkinstalldirs \
	`find "$(srcdir)" -type f -name Makefile.in -print` \
	`find "m4" -type f -name "*.m4" ! -name "as-compiler-flag.m4" ! -name "introspection.m4" ! -name "vala.m4" -print`

-include $(top_srcdir)/git.mk
