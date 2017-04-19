m4_define([valadate_major_version], [2])
m4_define([valadate_minor_version], [0])
m4_define([valadate_micro_version], [0])
m4_define([valadate_interface_age], [0])
m4_define([valadate_binary_age],
          [m4_eval(100 * valadate_minor_version + valadate_micro_version)])
m4_define([valadate_version],
          [valadate_major_version.valadate_minor_version.valadate_micro_version])

# libtool version related macros
m4_define([valadate_lt_release], [valadate_major_version.valadate_minor_version])
m4_define([valadate_lt_current],
          [m4_eval(100 * valadate_minor_version + valadate_micro_version - valadate_interface_age)])
m4_define([valadate_lt_revision], [valadate_interface_age])
m4_define([valadate_lt_age], [m4_eval(valadate_binary_age - valadate_interface_age)])
m4_define([valadate_lt_current_minus_age],
          [m4_eval(valadate_lt_current - valadate_lt_age)])

AC_INIT([Valadate],
        [valadate_version],
        [https://github.com/chebizarro/valadate/issues],
        [valadate],
        [https://github.com/chebizarro/valadate])

m4_ifdef([AM_SILENT_RULES], [AM_SILENT_RULES([yes])])

VALADATE_MAJOR_VERSION=valadate_major_version
VALADATE_MINOR_VERSION=valadate_minor_version
VALADATE_MICRO_VERSION=valadate_micro_version
VALADATE_INTERFACE_AGE=valadate_interface_age
VALADATE_BINARY_AGE=valadate_binary_age
VALADATE_VERSION=valadate_version

AC_SUBST(VALADATE_MAJOR_VERSION)
AC_SUBST(VALADATE_MINOR_VERSION)
AC_SUBST(VALADATE_MICRO_VERSION)
AC_SUBST(VALADATE_VERSION)
AC_SUBST(VALADATE_INTERFACE_AGE)
AC_SUBST(VALADATE_BINARY_AGE)

AC_DEFINE(VALADATE_MAJOR_VERSION, [valadate_major_version],
	  [Define to the Valadate major version])
AC_DEFINE(VALADATE_MINOR_VERSION, [valadate_minor_version],
	  [Define to the Valadate minor version])
AC_DEFINE(VALADATE_MICRO_VERSION, [valadate_micro_version],
	  [Define to the Valadate micro version])
AC_DEFINE(VALADATE_INTERFACE_AGE, [valadate_interface_age],
	  [Define to the Valadate interface age])
AC_DEFINE(VALADATE_BINARY_AGE, [valadate_binary_age],
	  [Define to the Valadate binary age])

# libtool versioning
LT_RELEASE=valadate_lt_release
LT_CURRENT=valadate_lt_current
LT_REVISION=valadate_lt_revision
LT_AGE=valadate_lt_age
LT_CURRENT_MINUS_AGE=valadate_lt_current_minus_age
AC_SUBST(LT_RELEASE)
AC_SUBST(LT_CURRENT)
AC_SUBST(LT_REVISION)
AC_SUBST(LT_AGE)
AC_SUBST(LT_CURRENT_MINUS_AGE)

AC_PREREQ([2.65])

AC_CONFIG_HEADER([config.h])
AC_CONFIG_SRCDIR([Makefile.am])
AC_CONFIG_AUX_DIR([build])
AC_CONFIG_MACRO_DIR([build/autotools])
AC_REQUIRE_AUX_FILE([tap-driver.sh])

AM_INIT_AUTOMAKE([1.11 foreign subdir-objects])

AM_MAINTAINER_MODE([enable])

AM_PROG_AR
AM_PATH_GLIB_2_0
AC_PROG_CC
AM_PROG_CC_C_O

AC_PATH_PROG(VALAC, valac, valac)
AC_SUBST(VALAC)

dnl === OS Check =======================================================

AC_CANONICAL_HOST

case $host_os in
  *mingw*)
    platform_win32=yes
    native_win32=yes
    platform_darwin=no
    platform_linux=no
    ;;
  *darwin*)
    platform_win32=no
    native_win32=no
    platform_darwin=yes
    platform_linux=no
    ;;
  *linux*)
    platform_win32=no
    native_win32=no
    platform_darwin=no
    platform_linux=yes
    ;;
  pw32* | *cygwin*)
    platform_win32=yes
    native_win32=no
    platform_darwin=no
    platform_linux=no
    ;;
  *)
    AC_MSG_ERROR([OS $host_os is currently not supported])
    ;;
esac
AM_CONDITIONAL(PLATFORM_WIN32, test x"$platform_win32" = "xyes")
AM_CONDITIONAL(NATIVE_WIN32, test x"$native_win32" = "xyes")
AM_CONDITIONAL(PLATFORM_DARWIN, test x"$platform_darwin" = "xyes")
AM_CONDITIONAL(PLATFORM_LINUX, test x"$platform_linux" = "xyes")

LT_PREREQ([2.2.6])
LT_INIT([disable-static win32-dll])

# Honor aclocal flags
ACLOCAL="$ACLOCAL $ACLOCAL_FLAGS"

dnl === Test suite =====================================================

GLIB_TESTS

dnl === Test coverage ==================================================

VALADATE_COVERAGE

dnl === Introspection ==================================================

GOBJECT_INTROSPECTION_CHECK([1.38.0])

dnl === Valadate =======================================================

pkg_modules="glib-2.0 gobject-2.0 gmodule-2.0 gio-2.0 libxml-2.0"
AC_SUBST(pkg_modules)

PKG_CHECK_MODULES([VALADATE], [$pkg_modules])
AC_SUBST(VALADATE_CFLAGS)
AC_SUBST(VALADATE_LIBS)

PKG_CHECK_MODULES([VALADATE_CLI], [$pkg_modules])
AC_SUBST(VALADATE_CLI_CFLAGS)
AC_SUBST(VALADATE_CLI_LIBS)

dnl === Valadate Tests =================================================

PKG_CHECK_MODULES([TESTS], [$pkg_modules])
AC_SUBST(TESTS_CFLAGS)
AC_SUBST(TESTS_LIBS)

dnl === Check for Development Mode =====================================

AC_ARG_ENABLE([devmode],
	AS_HELP_STRING([--enable-devmode],[Enable development mode]),
	[enable_devmode=$enableval], [enable_devmode=no])
AM_CONDITIONAL([ENABLE_DEVMODE], [test x$enable_devmode = xyes])

dnl === Vala Drivers ===================================================

AC_SUBST(VALAFLAGS)

PKG_CHECK_MODULES(LIBVALA_0_36_X, libvala-0.36 > 0.35.0, have_libvala_0_36_x="yes", have_libvala_0_36_x="no")
AM_CONDITIONAL(HAVE_LIBVALA_0_36_X, test "$have_libvala_0_36_x" = "yes")

PKG_CHECK_MODULES(LIBVALA_0_34_X, libvala-0.34 > 0.33.0, have_libvala_0_34_x="yes", have_libvala_0_34_x="no")
AM_CONDITIONAL(HAVE_LIBVALA_0_34_X, test "$have_libvala_0_34_x" = "yes")

PKG_CHECK_MODULES(LIBVALA_0_32_X, libvala-0.32 > 0.31.0, have_libvala_0_32_x="yes", have_libvala_0_32_x="no")
AM_CONDITIONAL(HAVE_LIBVALA_0_32_X, test "$have_libvala_0_32_x" = "yes")

PKG_CHECK_MODULES(LIBVALA_0_30_X, libvala-0.30 > 0.29.0, have_libvala_0_30_x="yes", have_libvala_0_30_x="no")
AM_CONDITIONAL(HAVE_LIBVALA_0_30_X, test "$have_libvala_0_30_x" = "yes")

PKG_CHECK_MODULES(LIBVALA_0_28_X, libvala-0.28 > 0.27.0, have_libvala_0_28_x="yes", have_libvala_0_28_x="no")
AM_CONDITIONAL(HAVE_LIBVALA_0_28_X, test "$have_libvala_0_28_x" = "yes")

PKG_CHECK_MODULES(LIBVALA_0_26_X, libvala-0.26 > 0.25.2, have_libvala_0_26_x="yes", have_libvala_0_26_x="no")
AM_CONDITIONAL(HAVE_LIBVALA_0_26_X, test "$have_libvala_0_26_x" = "yes")

PKG_CHECK_MODULES(LIBVALA_0_24_X, libvala-0.24 > 0.23.1, have_libvala_0_24_x="yes", have_libvala_0_24_x="no")
AM_CONDITIONAL(HAVE_LIBVALA_0_24_X, test "$have_libvala_0_24_x" = "yes")

PKG_CHECK_MODULES(LIBVALA_0_22_X, libvala-0.22 >= 0.21.0, have_libvala_0_22_x="yes", have_libvala_0_22_x="no")
AM_CONDITIONAL(HAVE_LIBVALA_0_22_X, test "$have_libvala_0_22_x" = "yes")

dnl === Docs ===========================================================

# Documentation with Valadoc
AC_ARG_ENABLE([docs],
	AS_HELP_STRING([--enable-docs],[Enable documentation generation]),
	[enable_docs=$enableval], [enable_docs=no])
AM_CONDITIONAL([ENABLE_DOCS], [test x$enable_docs = xyes])

have_valadoc=no
if test x$enable_docs = xyes; then
	# make sure the library is new enough and the program exists
	AC_PATH_PROG([VALADOC], [valadoc], [no])
	if test "x$VALADOC" = "xno";
	then
		AC_MSG_RESULT([valadoc documentation not built because not found])
	else
		have_valadoc="yes"
		AC_SUBST(VALADOC)
		PKG_CHECK_MODULES([GTKDOC], gtk-doc)
		have_gtkdoc=yes
	fi
fi
AM_CONDITIONAL([HAVE_VALADOC], [test x$have_valadoc = xyes])

dnl === Config variables set at build time =============================

AC_SUBST(VALADATE_LIB_DIR)
AC_SUBST(VALADATE_DRIVER_DIR)
AC_SUBST(VALADATE_TESTS_DIR)

dnl === Makefiles ======================================================

AC_CONFIG_FILES([
	Makefile
	build/Makefile
	build/autotools/Makefile
	libvaladate/Makefile
	libvaladate/libvaladate-2.0.pc
	libvaladate/valadate-2.0.pc
	libvaladate/drivers/Makefile
	libvaladate/drivers/0.32.x/Makefile
	tests/Makefile
	tests/genie/Makefile
	tests/libvaladate/Makefile
	tests/libvaladate/data/Makefile
	tests/libvaladate/src/Makefile
	tests/libvaladate/utils/Makefile
	tests/libvaladate/gdb/Makefile
	tests/PIE/Makefile
	tests/abstract-tests/Makefile
	vapi/Makefile
	docs/Makefile
])

AC_OUTPUT

dnl === Summary ========================================================

echo ""
echo " Valadate - $VERSION"
echo ""
echo " • Prefix: ${prefix}"
echo ""
echo " • Compiler flags: ${CFLAGS} ${MAINTAINER_CFLAGS} ${VALADATE_CFLAGS}"
echo ""
echo " • Enable code coverage: ${enable_coverage}"
echo ""
echo " • Building on: ${host_os}"
echo ""
echo " • Building documentation: ${enable_docs}"
echo ""
