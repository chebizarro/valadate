ACLOCAL_AMFLAGS = -I build/autotools ${ACLOCAL_FLAGS}
AUTOMAKE_OPTIONS = subdir-objects

AM_DISTCHECK_CONFIGURE_FLAGS = --enable-introspection

SUBDIRS = build libvaladate tests vapi

if ENABLE_DOCS
SUBDIRS += docs
endif

if ENABLE_COVERAGE
coverage:
	$(MAKE) coverage-reset
	-$(MAKE) $(AM_MAKEFLAGS) check
	$(MAKE) coverage-report

coverage-reset:
	lcov --base-directory=@top_srcdir@ --directory @top_srcdir@/libvaladate --zerocounters

coverage-report:
	lcov --directory @top_srcdir@/libvaladate \
		--capture \
		--output-file @top_builddir@/lcov.info

	lcov --directory @top_srcdir@/libvaladate \
		--output-file @top_builddir@/lcov.info \
		--remove @top_builddir@/lcov.info \
		"/usr/include/*" "*.c" "*.h" "*.vapi"

	$(mkdir_p) @top_builddir@/tests/coverage
	git_commit=`GIT_DIR=@top_srcdir@/.git git log -1 --pretty=format:%h 2>/dev/null`;\
	genhtml --title "@PACKAGE_STRING@ $$git_commit" \
		--output-directory @top_builddir@/tests/coverage @top_builddir@/lcov.info
	@echo
	@echo 'lcov report can be found in:'
	@echo 'file://@abs_top_builddir@/tests/coverage/index.html'
	@echo

clean-local:
	-rm -rf @top_builddir@/tests/coverage

else
coverage:
	@echo "The project has not been configured for coverage, check that you have gcov, lcov."
	@echo "Of course, do not use --disable-coverage"
	@exit 1
endif

.PHONY: coverage

MAINTAINERCLEANFILES = \
	configure \
	$(srcdir)/aclocal.m4 \
	$(srcdir)/build/compile \
	$(srcdir)/build/tap-driver.sh \
	$(srcdir)/build/config.guess \
	$(srcdir)/config.h.in \
	$(srcdir)/build/config.rpath \
	$(srcdir)/build/config.sub \
	$(srcdir)/build/depcomp \
	$(srcdir)/build/install-sh \
	$(srcdir)/build/ltmain.sh \
	$(srcdir)/build/missing \
	$(srcdir)/build/mkinstalldirs \
	`find "$(srcdir)" -type f -name Makefile.in -print`

gen_start_date = 2009-08-23
.PHONY: gen-ChangeLog
gen-ChangeLog:
	if test -d .git; then \
	  $(top_srcdir)/gitlog-to-changelog \
	    --since=$(gen_start_date) > $(distdir)/cl-t; \
	  rm -f $(distdir)/ChangeLog; \
	  mv $(distdir)/cl-t $(distdir)/ChangeLog; \
	fi

EXTRA_DIST = \
	$(noinst_DATA) \
	autogen.sh \
	vapi

GITIGNOREFILES = \
	autom4te.cache \
	aclocal.m4 \
	ar-lib \
	build/autotools/libtool.m4 \
	build/autotools/ltoptions.m4 \
	build/autotools/ltsugar.m4 \
	build/autotools/ltversion.m4 \
	build/autotools/lt~obsolete.m4 \
	compile \
	configure \
	config.guess \
	config.sub \
	depcomp \
	install-sh \
	ltmain.sh \
	missing \
	config.h.in \
	lcov.info

-include $(top_srcdir)/git.mk
