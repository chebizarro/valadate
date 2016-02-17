AC_PREREQ(2.63)
AC_INIT([library],
        [1.0.0],
        [https://github.com/chebizarro/valadate/issues],
        [library],
        [https://github.com/chebizarro/valadate])

AC_CONFIG_HEADER([config.h])
AC_CONFIG_SRCDIR([Makefile.am])
AC_CONFIG_AUX_DIR([build])
AC_CONFIG_MACRO_DIR([build/autotools])

AM_INIT_AUTOMAKE([1.11 foreign subdir-objects])

dnl AM_SILENT_RULES([yes])
AM_PATH_GLIB_2_0
AM_PROG_CC_C_O
AM_PROG_VALAC

LT_PREREQ([2.2.6])
LT_INIT([disable-static])

# Honor aclocal flags
ACLOCAL="$ACLOCAL $ACLOCAL_FLAGS"

LIBRARY_TESTS_DIR=[${PWD}/tests]
AC_SUBST(LIBRARY_TESTS_DIR)

pkg_modules="glib-2.0 gee-0.8 gtk+-3.0"
AC_SUBST(pkg_modules)

PKG_CHECK_MODULES([LIBRARY], [$pkg_modules])

AC_SUBST(LIBRARY_CFLAGS)


dnl === Test suite ============================================================

GLIB_TESTS

dnl === Test coverage =========================================================

AC_ARG_ENABLE([gcov],
              [AS_HELP_STRING([--enable-gcov], [Enable gcov])],
              [use_gcov=$enableval],
              [use_gcov=no])

AS_IF([test "x$use_gcov" = "xyes"],
      [
        dnl we need gcc:
        AS_IF([test "$GCC" != "yes"], [AC_MSG_ERROR([GCC is required for --enable-gcov])])

        dnl Check if ccache is being used
        AC_CHECK_PROG(SHTOOL, shtool, shtool)
        AS_CASE([`$SHTOOL path $CC`],
                [*ccache*], [gcc_ccache=yes],
                [gcc_ccache=no])

        if test "$gcc_ccache" = "yes" && (test -z "$CCACHE_DISABLE" || test "$CCACHE_DISABLE" != "1"); then
          AC_MSG_ERROR([ccache must be disabled when --enable-gcov option is used. You can disable ccache by setting environment variable CCACHE_DISABLE=1.])
        fi

        ltp_version_list="1.6 1.7 1.8 1.9 1.10 1.11"
        AC_CHECK_PROG(LTP, lcov, lcov)
        AC_CHECK_PROG(LTP_GENHTML, genhtml, genhtml)

        if test "$LTP"; then
          AC_CACHE_CHECK([for ltp version], library_cv_ltp_version,
                         [
                           library_cv_ltp_version=invalid
                           ltp_version=`$LTP -v 2>/dev/null | $SED -e 's/^.* //'`
                           for ltp_check_version in $ltp_version_list; do
                             if test "$ltp_version" = "$ltp_check_version"; then
                               library_cv_ltp_version="$ltp_check_version (ok)"
                             fi
                           done
                         ])
        else
          ltp_msg="To enable code coverage reporting you must have one of the following LTP versions installed: $ltp_version_list"
          AC_MSG_ERROR([$ltp_msg])
        fi

        case $library_cv_ltp_version in
          ""|invalid[)]
          ltp_msg="You must have one of the following versions of LTP: $ltp_version_list (found: $ltp_version)."
          AC_MSG_ERROR([$ltp_msg])
          LTP="exit 0;"
          ;;
        esac

        if test -z "$LTP_GENHTML"; then
          AC_MSG_ERROR([Could not find genhtml from the LTP package])
        fi

        AC_DEFINE(HAVE_GCOV, 1, [Whether you have gcov])

        dnl Remove all optimization flags from CFLAGS
        changequote({,})
        CFLAGS=`echo "$CFLAGS" | $SED -e 's/-O[0-9]*//g'`
        LIBRARY_CFLAGS=`echo "$LIBRARY_CFLAGS" | $SED -e 's/-O[0-9]*//g'`
        changequote([,])

        dnl Define the special gcc flags
        LIBRARY_GCOV_CFLAGS="-O0 -fprofile-arcs -ftest-coverage"
        LIBRARY_GCOV_LDADD="-lgcov"

        AC_SUBST(LIBRARY_GCOV_CFLAGS)
        AC_SUBST(LIBRARY_GCOV_LDADD)

        LIBRARY_CFLAGS="$LIBRARY_CFLAGS $LIBRARY_GCOV_CFLAGS"
        LIBRARY_LIBS="$LIBRARY_LIBS $LIBRARY_GCOV_LDADD"
      ])

AM_CONDITIONAL(ENABLE_GCOV, test "x$use_gcov" = "xyes")

AC_CONFIG_FILES([
	Makefile
	build/Makefile
	build/autotools/Makefile
	src/Makefile
	tests/Makefile
])

AC_OUTPUT

dnl === Summary ===============================================================

echo ""
echo " Library Sample for Valadate - $VERSION"
echo ""
echo " • Prefix: ${prefix}"
echo ""
echo " • Debug level: ${enable_debug}"
echo " • Compiler flags: ${CFLAGS} ${MAINTAINER_CFLAGS} ${LIBRARY_CFLAGS}"
echo ""
echo " • Install tests: ${ENABLE_INSTALLED_TESTS}"
echo " • Enable test coverage: ${use_gcov}"
echo ""
