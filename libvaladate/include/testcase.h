#ifndef __VALADATE_TESTCASE_H__
#define __VALADATE_TESTCASE_H__

#include <libvaladate.h>

#define valadate_test_case_assert(obj, expr) if G_LIKELY (expr) ; else valadate_test_case_assertion_message_expr (VALADATE_TEST_CASE(obj), G_LOG_DOMAIN, __FILE__, __LINE__, G_STRFUNC, #expr);

#define valadate_test_case_trap(obj, func, timeout) valadate_test_case_trap_func (VALADATE_TEST_CASE(obj), #func, timeout);

#endif /* __VALADATE_TESTCASE_H__ */
