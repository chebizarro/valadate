AC_PREREQ(2.63)
AC_INIT([valadate],
        [1.0.0],
        [https://github.com/chebizarro/valadate/issues],
        [valadate],
        [https://github.com/chebizarro/valadate])

AC_CONFIG_SRCDIR([Makefile.am])
AC_CONFIG_MACRO_DIR([m4])
dnl AC_CONFIG_HEADERS([config.h])
AM_INIT_AUTOMAKE([1.11 foreign subdir-objects])
AM_MAINTAINER_MODE([enable])

dnl AM_SILENT_RULES([yes])

AC_PROG_CC
AM_PROG_AR
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

LT_INIT([disable-static])

AC_PATH_PROG(GLIB_COMPILE_RESOURCES, glib-compile-resources)

pkg_modules="glib-2.0 gobject-2.0 gobject-introspection-1.0 libvala-0.30 gmodule-2.0"
AC_SUBST(pkg_modules)

PKG_CHECK_MODULES([VALADATE], [$pkg_modules])

AC_SUBST(VALADATE_CFLAGS)

AC_CONFIG_FILES([
	Makefile
	libvaladate/Makefile
	libvaladate/libvaladate-1.0.pc
	tests/Makefile
	tests/libvaladate/Makefile
	tests/PIE/Makefile
])

AC_OUTPUT
