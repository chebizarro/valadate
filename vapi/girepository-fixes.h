#include <girepository.h>

#define G_IINVOKE_ERROR G_INVOKE_ERROR
#define g_base_info_ref(x) (g_base_info_ref((GIBaseInfo *)(x)), (x))
#define g_base_info_unref(x) g_base_info_unref((GIBaseInfo *)(x))
