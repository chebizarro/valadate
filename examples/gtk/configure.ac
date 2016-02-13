AC_PREREQ(2.63)
AC_INIT([exampleapp],
        [0.0],
        [https://github.com/canek-pelaez/exampleapp/issues],
        [exampleapp],
        [https://github.com/canek-pelaez/exampleapp])
AC_CONFIG_SRCDIR([src/main.vala])

AC_CONFIG_AUX_DIR([build-aux])
AC_CONFIG_MACRO_DIR([build-aux])

AM_INIT_AUTOMAKE([1.11 foreign subdir-objects no-dist-gzip dist-xz])
dnl AM_SILENT_RULES([yes])

AM_PATH_GLIB_2_0
AC_PROG_CC
AM_PROG_CC_C_O
AC_PROG_CC_STDC
AM_PROG_VALAC([0.22])
AC_PROG_INSTALL

AC_PATH_PROG(GLIB_COMPILE_RESOURCES, glib-compile-resources)
AC_PATH_PROG(GLIB_COMPILE_SCHEMAS, glib-compile-schemas)

GLIB_GSETTINGS

EXAMPLE_PACKAGES="--pkg gtk+-3.0 --pkg gee-0.8"
PKG_CHECK_MODULES(EXAMPLE, [ gtk+-3.0 gee-0.8 ])

AC_SUBST(EXAMPLE_CFLAGS)
AC_SUBST(EXAMPLE_LIBS)
AC_SUBST(EXAMPLE_PACKAGES)

AC_ARG_ENABLE([docs],
        AS_HELP_STRING([--enable-docs], [Enable building documentation (default: no)]))
        AS_IF([test "x$enable_docs" = "xyes"], [
                    AC_PATH_PROG(YELP_BUILD, yelp-build)
])

AM_CONDITIONAL([DOCS], [test "x$YELP_BUILD" != "x"])

# Honor aclocal flags
ACLOCAL="$ACLOCAL $ACLOCAL_FLAGS"

EXAMPLE_TESTS_DIR=[${PWD}/tests]
AC_SUBST(EXAMPLE_TESTS_DIR)

LT_PREREQ([2.2.6])
LT_INIT([disable-static])


dnl === Test suite ============================================================

GLIB_TESTS


AC_CONFIG_FILES([
	Makefile
])

AC_OUTPUT
