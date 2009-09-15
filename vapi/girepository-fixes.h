#include <girepository.h>
#include <glib-object.h>

/* This define is here because I couldn't persuade vala to generate correct
 * name. */
#define G_IINVOKE_ERROR G_INVOKE_ERROR

/* Two wrappers because the g_base_info_ref/unref take a typed pointer, but
 * the subclass pointers obviously won't cast. */
#define g_base_info_ref(x) (g_base_info_ref((GIBaseInfo *)(x)), (x))
#define g_base_info_unref(x) g_base_info_unref((GIBaseInfo *)(x))

/* Helper function to cast the pointer in GArgument (Introspection.Argument)
 * to ValueArray and transfer the ownership. */
static inline GValueArray *g_iargument_steal_value_array(GArgument *self) {
    gpointer tmp = self->v_pointer;
    self->v_pointer = NULL;
    return tmp;
}
