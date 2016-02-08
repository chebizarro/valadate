AC_PREREQ(2.63)
AC_INIT([valadate],
        [1.0.0],
        [https://github.com/chebizarro/valadate/issues],
        [valadate],
        [https://github.com/chebizarro/valadate])

AC_CONFIG_HEADER([config.h])
AC_CONFIG_SRCDIR([Makefile.am])
AC_CONFIG_AUX_DIR([build])
AC_CONFIG_MACRO_DIR([build/autotools])

AM_INIT_AUTOMAKE([1.11 foreign subdir-objects])

dnl AM_MAINTAINER_MODE([enable])

dnl AM_SILENT_RULES([yes])
AM_PATH_GLIB_2_0
AM_PROG_CC_C_O
dnl AM_PROG_AR
AM_PROG_VALAC

dnl ***************************************************************************
dnl Check for Windows
dnl ***************************************************************************
AC_CANONICAL_HOST

case $host_os in
  *mingw*)
    platform_win32=yes
    native_win32=yes
    ;;
  pw32* | *cygwin*)
    platform_win32=yes
    native_win32=no
    ;;
  *)
    platform_win32=no
    native_win32=no
    ;;
esac
AM_CONDITIONAL(PLATFORM_WIN32, test x"$platform_win32" = "xyes")
AM_CONDITIONAL(NATIVE_WIN32, test x"$native_win32" = "xyes")

LT_PREREQ([2.2.6])
LT_INIT([disable-static])

# Honor aclocal flags
ACLOCAL="$ACLOCAL $ACLOCAL_FLAGS"

AC_PATH_PROG(GLIB_COMPILE_RESOURCES, glib-compile-resources)

VALADATE_TESTS_DIR=[${PWD}/tests]
AC_SUBST(VALADATE_TESTS_DIR)

pkg_modules="glib-2.0 gobject-2.0 gmodule-2.0"
AC_SUBST(pkg_modules)

PKG_CHECK_MODULES([VALADATE], [$pkg_modules])

AC_SUBST(VALADATE_CFLAGS)


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

        ltp_version_list="1.6 1.7 1.8 1.9 1.10"
        AC_CHECK_PROG(LTP, lcov, lcov)
        AC_CHECK_PROG(LTP_GENHTML, genhtml, genhtml)

        if test "$LTP"; then
          AC_CACHE_CHECK([for ltp version], valadate_cv_ltp_version,
                         [
                           valadate_cv_ltp_version=invalid
                           ltp_version=`$LTP -v 2>/dev/null | $SED -e 's/^.* //'`
                           for ltp_check_version in $ltp_version_list; do
                             if test "$ltp_version" = "$ltp_check_version"; then
                               valadate_cv_ltp_version="$ltp_check_version (ok)"
                             fi
                           done
                         ])
        else
          ltp_msg="To enable code coverage reporting you must have one of the following LTP versions installed: $ltp_version_list"
          AC_MSG_ERROR([$ltp_msg])
        fi

        case $valadate_cv_ltp_version in
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
        VALADATE_CFLAGS=`echo "$VALADATE_CFLAGS" | $SED -e 's/-O[0-9]*//g'`
        changequote([,])

        dnl Define the special gcc flags
        VALADATE_GCOV_CFLAGS="-O0 -fprofile-arcs -ftest-coverage"
        VALADATE_GCOV_LDADD="-lgcov"

        AC_SUBST(VALADATE_GCOV_CFLAGS)
        AC_SUBST(VALADATE_GCOV_LDADD)

        VALADATE_CFLAGS="$VALADATE_CFLAGS $VALADATE_GCOV_CFLAGS"
        VALADATE_LIBS="$VALADATE_LIBS $VALADATE_GCOV_LDADD"
      ])

AM_CONDITIONAL(ENABLE_GCOV, test "x$use_gcov" = "xyes")

AC_CONFIG_FILES([
	Makefile
	build/Makefile
	build/autotools/Makefile
	build/debian/Makefile
	libvaladate/Makefile
	libvaladate/libvaladate-1.0.pc
	tests/Makefile
	tests/libvaladate/Makefile
	tests/PIE/Makefile
	vapi/Makefile
])

AC_OUTPUT

dnl === Summary ===============================================================

echo ""
echo " Valadate - $VERSION"
echo ""
echo " • Prefix: ${prefix}"
echo ""
echo " • Debug level: ${enable_debug}"
echo " • Compiler flags: ${CFLAGS} ${MAINTAINER_CFLAGS} ${VALADATE_CFLAGS}"
echo ""
echo " • API reference: ${enable_gtk_doc}"
echo " • Manual pages: ${enable_man}"
echo ""
echo " • Install tests: ${ENABLE_INSTALLED_TESTS}"
echo " • Enable test coverage: ${use_gcov}"
echo ""
