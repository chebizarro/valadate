AC_PREREQ(2.63)
AC_INIT([valadate-docs-1.0],
        [1.0.0],
        [https://github.com/chebizarro/valadate/issues],
        [valadate],
        [https://github.com/chebizarro/valadate])

dnl AC_CONFIG_HEADER([config.h])
AC_CONFIG_SRCDIR([Makefile.am])
AC_CONFIG_AUX_DIR([build])

AM_INIT_AUTOMAKE([1.11 foreign])

AM_MAINTAINER_MODE([enable])

AM_SILENT_RULES([yes])

dnl AM_PATH_GLIB_2_0
dnl AM_PROG_CC_C_O
dnl AM_PROG_AR
dnl AC_PATH_PROG(VALAC, valac, valac)
dnl AC_SUBST(VALAC)

dnl ***************************************************************************
dnl Check for OS
dnl ***************************************************************************
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


GTK_DOC_CHECK([1.0],[--flavour=no-tmpl])

AC_PATH_PROG(VALADOC, valadoc, :)

AS_IF([test -x "$VALADOC"], [
found_valadoc=yes
AC_SUBST(VALADOC)
], [
AC_MSG_ERROR([Unable to find valadoc])
])


AC_CONFIG_FILES([
	Makefile
])

AC_OUTPUT

dnl === Summary ===============================================================

echo ""
echo " Valadate Docs - $VERSION"
echo ""
echo " • Enable valadoc: ${found_valadoc}"
echo ""
