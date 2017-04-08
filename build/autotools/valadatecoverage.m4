dnl VALADATE_COVERAGE
dnl

AC_DEFUN([VALADATE_COVERAGE],
[
	AC_ARG_ENABLE(coverage,
		AS_HELP_STRING([--enable-coverage],
		[compile with coverage profiling and debug (gcc only)]),
		enable_coverage=$enableval,enable_coverage=no)
	AM_CONDITIONAL(ENABLE_COVERAGE, test x$enable_coverage != xno)
	AS_IF([test "x$enable_coverage" != xno],
		[COVERAGE_CFLAGS="-O0 -fprofile-arcs -ftest-coverage"
		 COVERAGE_VALAFLAGS="-g"
		 COVERAGE_LIBS="-lgcov"
		 AC_SUBST(COVERAGE_CFLAGS)
		 AC_SUBST(COVERAGE_VALAFLAGS)
		 AC_SUBST(COVERAGE_LIBS)
		 AC_PATH_PROG(LCOV, lcov, :)
		 AC_SUBST(LCOV)
		 AS_IF([test "$LCOV" = :],
			[AC_MSG_ERROR([lcov is necessary for testing code coverage (http://ltp.sourceforge.net/coverage/lcov.php)])])])
])
