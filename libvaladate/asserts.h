#define valadate_test_case_assert(obj, expr) if G_LIKELY (expr) ; else valadate_test_case_assertion_message_expr (VALADATE_TEST_CASE(obj), G_LOG_DOMAIN, __FILE__, __LINE__, G_STRFUNC, #expr);
