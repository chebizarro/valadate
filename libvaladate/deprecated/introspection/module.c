/* module.c generated by valac 0.34.7, the Vala compiler
 * generated from module.vala, do not modify */

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
#include <stdlib.h>
#include <string.h>
#include <gmodule.h>
#include <gio/gio.h>


#define VALADATE_INTROSPECTION_TYPE_MODULE (valadate_introspection_module_get_type ())
#define VALADATE_INTROSPECTION_MODULE(obj) (G_TYPE_CHECK_INSTANCE_CAST ((obj), VALADATE_INTROSPECTION_TYPE_MODULE, ValadateIntrospectionModule))
#define VALADATE_INTROSPECTION_MODULE_CLASS(klass) (G_TYPE_CHECK_CLASS_CAST ((klass), VALADATE_INTROSPECTION_TYPE_MODULE, ValadateIntrospectionModuleClass))
#define VALADATE_INTROSPECTION_IS_MODULE(obj) (G_TYPE_CHECK_INSTANCE_TYPE ((obj), VALADATE_INTROSPECTION_TYPE_MODULE))
#define VALADATE_INTROSPECTION_IS_MODULE_CLASS(klass) (G_TYPE_CHECK_CLASS_TYPE ((klass), VALADATE_INTROSPECTION_TYPE_MODULE))
#define VALADATE_INTROSPECTION_MODULE_GET_CLASS(obj) (G_TYPE_INSTANCE_GET_CLASS ((obj), VALADATE_INTROSPECTION_TYPE_MODULE, ValadateIntrospectionModuleClass))

typedef struct _ValadateIntrospectionModule ValadateIntrospectionModule;
typedef struct _ValadateIntrospectionModuleClass ValadateIntrospectionModuleClass;
typedef struct _ValadateIntrospectionModulePrivate ValadateIntrospectionModulePrivate;
#define _g_free0(var) (var = (g_free (var), NULL))
#define _g_module_close0(var) ((var == NULL) ? NULL : (var = (g_module_close (var), NULL)))
#define _g_object_unref0(var) ((var == NULL) ? NULL : (var = (g_object_unref (var), NULL)))
#define _vala_assert(expr, msg) if G_LIKELY (expr) ; else g_assertion_message_expr (G_LOG_DOMAIN, __FILE__, __LINE__, G_STRFUNC, msg);
#define _vala_return_if_fail(expr, msg) if G_LIKELY (expr) ; else { g_return_if_fail_warning (G_LOG_DOMAIN, G_STRFUNC, msg); return; }
#define _vala_return_val_if_fail(expr, msg, val) if G_LIKELY (expr) ; else { g_return_if_fail_warning (G_LOG_DOMAIN, G_STRFUNC, msg); return val; }
#define _vala_warn_if_fail(expr, msg) if G_LIKELY (expr) ; else g_warn_message (G_LOG_DOMAIN, __FILE__, __LINE__, G_STRFUNC, msg);

struct _ValadateIntrospectionModule {
	GObject parent_instance;
	ValadateIntrospectionModulePrivate * priv;
};

struct _ValadateIntrospectionModuleClass {
	GObjectClass parent_class;
};

struct _ValadateIntrospectionModulePrivate {
	gchar* lib_path;
	GModule* module;
};

typedef enum  {
	VALADATE_INTROSPECTION_ERROR_MODULE,
	VALADATE_INTROSPECTION_ERROR_GIR,
	VALADATE_INTROSPECTION_ERROR_PARSER,
	VALADATE_INTROSPECTION_ERROR_TESTS,
	VALADATE_INTROSPECTION_ERROR_METHOD
} ValadateIntrospectionError;
#define VALADATE_INTROSPECTION_ERROR valadate_introspection_error_quark ()

static gpointer valadate_introspection_module_parent_class = NULL;

GType valadate_introspection_module_get_type (void) G_GNUC_CONST;
#define VALADATE_INTROSPECTION_MODULE_GET_PRIVATE(o) (G_TYPE_INSTANCE_GET_PRIVATE ((o), VALADATE_INTROSPECTION_TYPE_MODULE, ValadateIntrospectionModulePrivate))
enum  {
	VALADATE_INTROSPECTION_MODULE_DUMMY_PROPERTY
};
ValadateIntrospectionModule* valadate_introspection_module_new (const gchar* libpath);
ValadateIntrospectionModule* valadate_introspection_module_construct (GType object_type, const gchar* libpath);
GQuark valadate_introspection_error_quark (void);
void valadate_introspection_module_load_module (ValadateIntrospectionModule* self, GError** error);
G_GNUC_INTERNAL void* valadate_introspection_module_get_method (ValadateIntrospectionModule* self, const gchar* method_name, GError** error);
static void valadate_introspection_module_finalize (GObject* obj);


ValadateIntrospectionModule* valadate_introspection_module_construct (GType object_type, const gchar* libpath) {
	ValadateIntrospectionModule * self = NULL;
	const gchar* _tmp0_ = NULL;
	gchar* _tmp1_ = NULL;
#line 28 "/home/developer/valadate/libvaladate/introspection/module.vala"
	g_return_val_if_fail (libpath != NULL, NULL);
#line 28 "/home/developer/valadate/libvaladate/introspection/module.vala"
	self = (ValadateIntrospectionModule*) g_object_new (object_type, NULL);
#line 29 "/home/developer/valadate/libvaladate/introspection/module.vala"
	_tmp0_ = libpath;
#line 29 "/home/developer/valadate/libvaladate/introspection/module.vala"
	_tmp1_ = g_strdup (_tmp0_);
#line 29 "/home/developer/valadate/libvaladate/introspection/module.vala"
	_g_free0 (self->priv->lib_path);
#line 29 "/home/developer/valadate/libvaladate/introspection/module.vala"
	self->priv->lib_path = _tmp1_;
#line 28 "/home/developer/valadate/libvaladate/introspection/module.vala"
	return self;
#line 105 "module.c"
}


ValadateIntrospectionModule* valadate_introspection_module_new (const gchar* libpath) {
#line 28 "/home/developer/valadate/libvaladate/introspection/module.vala"
	return valadate_introspection_module_construct (VALADATE_INTROSPECTION_TYPE_MODULE, libpath);
#line 112 "module.c"
}


void valadate_introspection_module_load_module (ValadateIntrospectionModule* self, GError** error) {
	const gchar* _tmp0_ = NULL;
	const gchar* _tmp1_ = NULL;
	GFile* _tmp2_ = NULL;
	GFile* _tmp3_ = NULL;
	gboolean _tmp4_ = FALSE;
	gboolean _tmp5_ = FALSE;
	const gchar* _tmp8_ = NULL;
	GModule* _tmp9_ = NULL;
	GModule* _tmp10_ = NULL;
	GModule* _tmp13_ = NULL;
	GError * _inner_error_ = NULL;
#line 32 "/home/developer/valadate/libvaladate/introspection/module.vala"
	g_return_if_fail (self != NULL);
#line 32 "/home/developer/valadate/libvaladate/introspection/module.vala"
	_tmp0_ = self->priv->lib_path;
#line 32 "/home/developer/valadate/libvaladate/introspection/module.vala"
	_vala_return_if_fail (_tmp0_ != NULL, "lib_path != null");
#line 35 "/home/developer/valadate/libvaladate/introspection/module.vala"
	_tmp1_ = self->priv->lib_path;
#line 35 "/home/developer/valadate/libvaladate/introspection/module.vala"
	_tmp2_ = g_file_new_for_path (_tmp1_);
#line 35 "/home/developer/valadate/libvaladate/introspection/module.vala"
	_tmp3_ = _tmp2_;
#line 35 "/home/developer/valadate/libvaladate/introspection/module.vala"
	_tmp4_ = g_file_query_exists (_tmp3_, NULL);
#line 35 "/home/developer/valadate/libvaladate/introspection/module.vala"
	_tmp5_ = !_tmp4_;
#line 35 "/home/developer/valadate/libvaladate/introspection/module.vala"
	_g_object_unref0 (_tmp3_);
#line 35 "/home/developer/valadate/libvaladate/introspection/module.vala"
	if (_tmp5_) {
#line 148 "module.c"
		const gchar* _tmp6_ = NULL;
		GError* _tmp7_ = NULL;
#line 36 "/home/developer/valadate/libvaladate/introspection/module.vala"
		_tmp6_ = self->priv->lib_path;
#line 36 "/home/developer/valadate/libvaladate/introspection/module.vala"
		_tmp7_ = g_error_new (VALADATE_INTROSPECTION_ERROR, VALADATE_INTROSPECTION_ERROR_MODULE, "Module: %s does not exist", _tmp6_);
#line 36 "/home/developer/valadate/libvaladate/introspection/module.vala"
		_inner_error_ = _tmp7_;
#line 36 "/home/developer/valadate/libvaladate/introspection/module.vala"
		if (_inner_error_->domain == VALADATE_INTROSPECTION_ERROR) {
#line 36 "/home/developer/valadate/libvaladate/introspection/module.vala"
			g_propagate_error (error, _inner_error_);
#line 36 "/home/developer/valadate/libvaladate/introspection/module.vala"
			return;
#line 163 "module.c"
		} else {
#line 36 "/home/developer/valadate/libvaladate/introspection/module.vala"
			g_critical ("file %s: line %d: uncaught error: %s (%s, %d)", __FILE__, __LINE__, _inner_error_->message, g_quark_to_string (_inner_error_->domain), _inner_error_->code);
#line 36 "/home/developer/valadate/libvaladate/introspection/module.vala"
			g_clear_error (&_inner_error_);
#line 36 "/home/developer/valadate/libvaladate/introspection/module.vala"
			return;
#line 171 "module.c"
		}
	}
#line 38 "/home/developer/valadate/libvaladate/introspection/module.vala"
	_tmp8_ = self->priv->lib_path;
#line 38 "/home/developer/valadate/libvaladate/introspection/module.vala"
	_tmp9_ = g_module_open (_tmp8_, G_MODULE_BIND_LOCAL);
#line 38 "/home/developer/valadate/libvaladate/introspection/module.vala"
	_g_module_close0 (self->priv->module);
#line 38 "/home/developer/valadate/libvaladate/introspection/module.vala"
	self->priv->module = _tmp9_;
#line 39 "/home/developer/valadate/libvaladate/introspection/module.vala"
	_tmp10_ = self->priv->module;
#line 39 "/home/developer/valadate/libvaladate/introspection/module.vala"
	if (_tmp10_ == NULL) {
#line 186 "module.c"
		const gchar* _tmp11_ = NULL;
		GError* _tmp12_ = NULL;
#line 40 "/home/developer/valadate/libvaladate/introspection/module.vala"
		_tmp11_ = g_module_error ();
#line 40 "/home/developer/valadate/libvaladate/introspection/module.vala"
		_tmp12_ = g_error_new_literal (VALADATE_INTROSPECTION_ERROR, VALADATE_INTROSPECTION_ERROR_MODULE, _tmp11_);
#line 40 "/home/developer/valadate/libvaladate/introspection/module.vala"
		_inner_error_ = _tmp12_;
#line 40 "/home/developer/valadate/libvaladate/introspection/module.vala"
		if (_inner_error_->domain == VALADATE_INTROSPECTION_ERROR) {
#line 40 "/home/developer/valadate/libvaladate/introspection/module.vala"
			g_propagate_error (error, _inner_error_);
#line 40 "/home/developer/valadate/libvaladate/introspection/module.vala"
			return;
#line 201 "module.c"
		} else {
#line 40 "/home/developer/valadate/libvaladate/introspection/module.vala"
			g_critical ("file %s: line %d: uncaught error: %s (%s, %d)", __FILE__, __LINE__, _inner_error_->message, g_quark_to_string (_inner_error_->domain), _inner_error_->code);
#line 40 "/home/developer/valadate/libvaladate/introspection/module.vala"
			g_clear_error (&_inner_error_);
#line 40 "/home/developer/valadate/libvaladate/introspection/module.vala"
			return;
#line 209 "module.c"
		}
	}
#line 41 "/home/developer/valadate/libvaladate/introspection/module.vala"
	_tmp13_ = self->priv->module;
#line 41 "/home/developer/valadate/libvaladate/introspection/module.vala"
	g_module_make_resident (_tmp13_);
#line 216 "module.c"
}


G_GNUC_INTERNAL void* valadate_introspection_module_get_method (ValadateIntrospectionModule* self, const gchar* method_name, GError** error) {
	void* result = NULL;
	void* function = NULL;
	GModule* _tmp0_ = NULL;
	const gchar* _tmp1_ = NULL;
	void* _tmp2_ = NULL;
	gboolean _tmp3_ = FALSE;
	const gchar* _tmp6_ = NULL;
	GError* _tmp7_ = NULL;
	GError * _inner_error_ = NULL;
#line 44 "/home/developer/valadate/libvaladate/introspection/module.vala"
	g_return_val_if_fail (self != NULL, NULL);
#line 44 "/home/developer/valadate/libvaladate/introspection/module.vala"
	g_return_val_if_fail (method_name != NULL, NULL);
#line 46 "/home/developer/valadate/libvaladate/introspection/module.vala"
	_tmp0_ = self->priv->module;
#line 46 "/home/developer/valadate/libvaladate/introspection/module.vala"
	_tmp1_ = method_name;
#line 46 "/home/developer/valadate/libvaladate/introspection/module.vala"
	_tmp3_ = g_module_symbol (_tmp0_, _tmp1_, &_tmp2_);
#line 46 "/home/developer/valadate/libvaladate/introspection/module.vala"
	function = _tmp2_;
#line 46 "/home/developer/valadate/libvaladate/introspection/module.vala"
	if (_tmp3_) {
#line 244 "module.c"
		void* _tmp4_ = NULL;
#line 47 "/home/developer/valadate/libvaladate/introspection/module.vala"
		_tmp4_ = function;
#line 47 "/home/developer/valadate/libvaladate/introspection/module.vala"
		if (_tmp4_ != NULL) {
#line 250 "module.c"
			void* _tmp5_ = NULL;
#line 48 "/home/developer/valadate/libvaladate/introspection/module.vala"
			_tmp5_ = function;
#line 48 "/home/developer/valadate/libvaladate/introspection/module.vala"
			result = _tmp5_;
#line 48 "/home/developer/valadate/libvaladate/introspection/module.vala"
			return result;
#line 258 "module.c"
		}
	}
#line 49 "/home/developer/valadate/libvaladate/introspection/module.vala"
	_tmp6_ = g_module_error ();
#line 49 "/home/developer/valadate/libvaladate/introspection/module.vala"
	_tmp7_ = g_error_new_literal (VALADATE_INTROSPECTION_ERROR, VALADATE_INTROSPECTION_ERROR_METHOD, _tmp6_);
#line 49 "/home/developer/valadate/libvaladate/introspection/module.vala"
	_inner_error_ = _tmp7_;
#line 49 "/home/developer/valadate/libvaladate/introspection/module.vala"
	if (_inner_error_->domain == VALADATE_INTROSPECTION_ERROR) {
#line 49 "/home/developer/valadate/libvaladate/introspection/module.vala"
		g_propagate_error (error, _inner_error_);
#line 49 "/home/developer/valadate/libvaladate/introspection/module.vala"
		return NULL;
#line 273 "module.c"
	} else {
#line 49 "/home/developer/valadate/libvaladate/introspection/module.vala"
		g_critical ("file %s: line %d: uncaught error: %s (%s, %d)", __FILE__, __LINE__, _inner_error_->message, g_quark_to_string (_inner_error_->domain), _inner_error_->code);
#line 49 "/home/developer/valadate/libvaladate/introspection/module.vala"
		g_clear_error (&_inner_error_);
#line 49 "/home/developer/valadate/libvaladate/introspection/module.vala"
		return NULL;
#line 281 "module.c"
	}
}


static void valadate_introspection_module_class_init (ValadateIntrospectionModuleClass * klass) {
#line 23 "/home/developer/valadate/libvaladate/introspection/module.vala"
	valadate_introspection_module_parent_class = g_type_class_peek_parent (klass);
#line 23 "/home/developer/valadate/libvaladate/introspection/module.vala"
	g_type_class_add_private (klass, sizeof (ValadateIntrospectionModulePrivate));
#line 23 "/home/developer/valadate/libvaladate/introspection/module.vala"
	G_OBJECT_CLASS (klass)->finalize = valadate_introspection_module_finalize;
#line 293 "module.c"
}


static void valadate_introspection_module_instance_init (ValadateIntrospectionModule * self) {
#line 23 "/home/developer/valadate/libvaladate/introspection/module.vala"
	self->priv = VALADATE_INTROSPECTION_MODULE_GET_PRIVATE (self);
#line 300 "module.c"
}


static void valadate_introspection_module_finalize (GObject* obj) {
	ValadateIntrospectionModule * self;
#line 23 "/home/developer/valadate/libvaladate/introspection/module.vala"
	self = G_TYPE_CHECK_INSTANCE_CAST (obj, VALADATE_INTROSPECTION_TYPE_MODULE, ValadateIntrospectionModule);
#line 25 "/home/developer/valadate/libvaladate/introspection/module.vala"
	_g_free0 (self->priv->lib_path);
#line 26 "/home/developer/valadate/libvaladate/introspection/module.vala"
	_g_module_close0 (self->priv->module);
#line 23 "/home/developer/valadate/libvaladate/introspection/module.vala"
	G_OBJECT_CLASS (valadate_introspection_module_parent_class)->finalize (obj);
#line 314 "module.c"
}


GType valadate_introspection_module_get_type (void) {
	static volatile gsize valadate_introspection_module_type_id__volatile = 0;
	if (g_once_init_enter (&valadate_introspection_module_type_id__volatile)) {
		static const GTypeInfo g_define_type_info = { sizeof (ValadateIntrospectionModuleClass), (GBaseInitFunc) NULL, (GBaseFinalizeFunc) NULL, (GClassInitFunc) valadate_introspection_module_class_init, (GClassFinalizeFunc) NULL, NULL, sizeof (ValadateIntrospectionModule), 0, (GInstanceInitFunc) valadate_introspection_module_instance_init, NULL };
		GType valadate_introspection_module_type_id;
		valadate_introspection_module_type_id = g_type_register_static (G_TYPE_OBJECT, "ValadateIntrospectionModule", &g_define_type_info, 0);
		g_once_init_leave (&valadate_introspection_module_type_id__volatile, valadate_introspection_module_type_id);
	}
	return valadate_introspection_module_type_id__volatile;
}



