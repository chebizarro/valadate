/* testrunner.c generated by valac 0.30.0, the Vala compiler
 * generated from testrunner.vala, do not modify */

/*
 * Valadate - Unit testing library for GObject-based libraries.
 * Copyright (C) 20016  Chris Daley <chebizarro@gmail.com>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published
 * by the Free Software Foundation, either version 3 of the License, or (at
 * your option) any later version.
 *
 * This program is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
 * or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Lesser General Public
 * License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#include <glib.h>
#include <glib-object.h>


#define VALADATE_TYPE_TEST_RUNNER (valadate_test_runner_get_type ())
#define VALADATE_TEST_RUNNER(obj) (G_TYPE_CHECK_INSTANCE_CAST ((obj), VALADATE_TYPE_TEST_RUNNER, ValadateTestRunner))
#define VALADATE_IS_TEST_RUNNER(obj) (G_TYPE_CHECK_INSTANCE_TYPE ((obj), VALADATE_TYPE_TEST_RUNNER))
#define VALADATE_TEST_RUNNER_GET_INTERFACE(obj) (G_TYPE_INSTANCE_GET_INTERFACE ((obj), VALADATE_TYPE_TEST_RUNNER, ValadateTestRunnerIface))

typedef struct _ValadateTestRunner ValadateTestRunner;
typedef struct _ValadateTestRunnerIface ValadateTestRunnerIface;

struct _ValadateTestRunnerIface {
	GTypeInterface parent_iface;
};



GType valadate_test_runner_get_type (void) G_GNUC_CONST;


static void valadate_test_runner_base_init (ValadateTestRunnerIface * iface) {
#line 21 "/home/bizarro/Documents/projects/valadate/libvaladate/testrunner.vala"
	static gboolean initialized = FALSE;
#line 21 "/home/bizarro/Documents/projects/valadate/libvaladate/testrunner.vala"
	if (!initialized) {
#line 21 "/home/bizarro/Documents/projects/valadate/libvaladate/testrunner.vala"
		initialized = TRUE;
#line 51 "testrunner.c"
	}
}


GType valadate_test_runner_get_type (void) {
	static volatile gsize valadate_test_runner_type_id__volatile = 0;
	if (g_once_init_enter (&valadate_test_runner_type_id__volatile)) {
		static const GTypeInfo g_define_type_info = { sizeof (ValadateTestRunnerIface), (GBaseInitFunc) valadate_test_runner_base_init, (GBaseFinalizeFunc) NULL, (GClassInitFunc) NULL, (GClassFinalizeFunc) NULL, NULL, 0, 0, (GInstanceInitFunc) NULL, NULL };
		GType valadate_test_runner_type_id;
		valadate_test_runner_type_id = g_type_register_static (G_TYPE_INTERFACE, "ValadateTestRunner", &g_define_type_info, 0);
		g_type_interface_add_prerequisite (valadate_test_runner_type_id, G_TYPE_OBJECT);
		g_once_init_leave (&valadate_test_runner_type_id__volatile, valadate_test_runner_type_id);
	}
	return valadate_test_runner_type_id__volatile;
}



