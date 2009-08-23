using GLib;

[CCode (cprefix = "GI", lower_case_cprefix = "g_i", cheader_filename = "girepository.h")]
namespace Introspection {

	[CCode (cprefix = "G_IREPOSITORY_ERROR_")]
	errordomain RepositoryError {
		TYPELIB_NOT_FOUND,
		NAMESPACE_MISMATCH,
		NAMESPACE_VERSION_CONFLICT,
		LIBRARY_NOT_FOUND
	}

	[CCode (cname="int", cprefix = "G_IREPOSITORY_LOAD_FLAG_")]
	public enum RepositoryLoadFlags {
		LAZY
	}

	[CCode (ref_function = "", unref_function = "")]
	public class Repository {
		public static unowned Repository get_default ();
		public static void prepend_search_path (string directory);
		public static unowned SList<string> get_search_path ();

		public unowned string load_typelib (Typelib typelib, RepositoryLoadFlags flags) throws RepositoryError;
		public bool is_registered (string namespace_, string version);
		public BaseInfo? find_by_name (string namespace_, string name);
		public Typelib require (string namespace_, string? version = null, RepositoryLoadFlags flags = 0) throws RepositoryError;
		public string[] get_dependencies (string namespace_);
		public string[] get_loaded_namespaces ();
		public BaseInfo? find_by_gtype (Type type);
		public int get_n_infos (string namespace_);
		public BaseInfo get_info (string namespace_, int index);
		public unowned string get_c_prefix (string namespace_);
		public unowned string get_typelib_path (string namespace_);
		public unowned string get_shared_library (string namespace_);
		public unowned string get_version (string namespace_);

		public static OptionGroup get_option_group ();
		public static bool dump (string arg) throws RepositoryError;
	}

	[Compact]
	[CCode (cname = "GTypelib", cprefix = "g_typelib_", free_function = "g_typelib_free")]
	public class Typelib {
		public static Typelib new_from_memory (uchar[] memory);
		public static Typelib new_from_const_memory (uchar[] memory);
		public static Typelib new_from_mapped_file (MappedFile mfile);

		public bool symbol (string name, out void* symbol);
		public unowned string get_namespace ();
	}

	[CCode (cprefix = "GI_INFO_TYPE_")]
	public enum InfoType {
		INVALID,
		FUNCTION,
		CALLBACK,
		STRUCT,
		BOXED,
		ENUM,
		FLAGS,
		OBJECT,
		INTERFACE,
		CONSTANT,
		ERROR_DOMAIN,
		UNION,
		VALUE,
		SIGNAL,
		VFUNC,
		PROPERTY,
		FIELD,
		ARG,
		TYPE,
		UNRESOLVED
	}

	public struct AttributeIter {
		public void* data;
		public void* data2;
		public void* data3;
		public void* data4;
	}

	[Compact]
	[CCode (cprefix = "g_base_info_", ref_function = "g_base_info_ref", unref_function = "g_base_info_unref")]
	public class BaseInfo {
		[CCode (cname = "g_info_new")]
		public static BaseInfo @new (InfoType type, BaseInfo container, Typelib typelib, uint offset);

		public InfoType get_type ();
		public unowned string get_name ();
		public unowned string get_namespace ();
		public unowned string get_attribute (string name);
		public bool is_deprecated ();
		public bool iterate_attributes (ref AttributeIter iterator, out string name, out string value); // XXX: bogus in GIR
		public unowned BaseInfo get_container (); // XXX: owned in GIR
		public unowned Typelib get_typelib (); // XXX: owned in GIR
	}

	[Flags]
	[CCode (cprefix = "GI_FUNCTION_")]
	public enum FunctionInfoFlags {
		IS_METHOD,
		IS_CONSTRUCTOR,
		IS_GETTER,
		IS_SETTER,
		WRAPS_VFUNC,
		THROWS
	}

	[CCode (cprefix = "G_INVOKE_ERROR_")]
	errordomain InvokeError {
		FAILED,
		SYMBOL_NOT_FOUND,
		ARGUMENT_MISMATCH
	}

	[Compact]
	[CCode (cprefix = "g_function_info_")]
	public class FunctionInfo : CallableInfo {
		public unowned string get_symbol ();
		public FunctionInfoFlags get_flags ();
		public PropertyInfo get_property ();
		public VFuncInfo get_vfunc ();

		public bool invoke(Argument[] in_args, Argument[] out_args, out Argument return_value) throws InvokeError;
	}

	[CCode (cname="GArgument", cprefix = "v_")]
	public struct Argument {
		bool @boolean;
		int8 @int8;
		uint8 @uint8;
		int16 @int16;
		uint16 @uint16;
		int32 @int32;
		uint32 @uint32;
		int64 @int64;
		uint64 @uint64;
		float @float;
		double @double;
		int @int;
		uint @uint;
		long @long;
		ulong @ulong;
		ssize_t @ssize;
		size_t @size;
		weak string @string;
		void* @pointer;
	}

	[CCode (cprefix = "GI_TRANSFER_")]
	public enum Transfer {
		NOTHING,
		CONTAINER,
		EVERYTHING
	}

	[Compact]
	[CCode (cprefix = "g_callable_info_")]
	public class CallableInfo : BaseInfo {
		public TypeInfo get_return_type ();
		public Transfer get_caller_owns ();
		public bool may_return_null ();
		public int get_n_args ();
		public ArgInfo get_arg (int index);
	}

	[CCode (cprefix = "GI_DIRECTION_")]
	public enum Direction {
		IN,
		OUT,
		INOUT
	}

	[CCode (cprefix = "GI_SCOPE_TYPE_")]
	public enum ScopeType {
		INVALID,
		CALL,
		ASYNC,
		NOTIFIED
	}

	[Compact]
	[CCode (cname="GIArgInfo", cprefix = "g_arg_info_")]
	public class ArgInfo : BaseInfo {
		public Direction get_direction ();
		public bool is_dipper ();
		public bool is_return_value ();
		public bool is_optional ();
		public bool may_be_null ();
		public Transfer get_ownership_transfer ();
		public ScopeType get_scope ();
		public int get_closure ();
		public int get_destroy ();
		public TypeInfo get_type ();
	}

	[CCode (cprefix = "GI_TYPE_TAG_")]
	public enum TypeTag {
		VOID,
		BOOLEAN,
		INT8,
		UINT8,
		INT16,
		UINT16,
		INT32,
		UINT32,
		INT64,
		UINT64,
		SHORT,
		USHORT,
		INT,
		UINT,
		LONG,
		ULONG,
		SSIZE,
		SIZE,
		FLOAT,
		DOUBLE,
		TIME_T,
		GTYPE,
		UTF8,
		FILENAME,
		ARRAY,
		INTERFACE,
		GLIST,
		GSLIST,
		GHASH,
		ERROR;

		[CCode (cname = "g_type_tag_to_string")]
		public unowned string to_string ();
	}

	[Compact]
	[CCode (cprefix = "g_type_info_")]
	public class TypeInfo : BaseInfo {
		public bool is_pointer ();
		public TypeTag get_tag ();
		public TypeInfo get_param_type (int index);
		public BaseInfo get_interface ();
		public int get_array_length ();
		public int get_array_fixed_size ();
		public bool is_zero_terminated ();
		public int get_n_error_domains ();
		public ErrorDomainInfo get_error_domain (int index);
	}

	[Compact]
	[CCode (cprefix = "g_error_domain_info_")]
	public class ErrorDomainInfo : BaseInfo {
		public unowned string get_quark ();
		public InterfaceInfo get_codes ();
	}

	[Compact]
	[CCode (cprefix = "g_value_info_")]
	public class ValueInfo : BaseInfo {
		public long get_value ();
	}

	[Flags]
	[CCode (cprefix = "GI_FIELD_")]
	public enum FieldInfoFlags {
		IS_READABLE,
		IS_WRITABLE
	}

	[Compact]
	[CCode (cprefix = "g_field_info_")]
	public class FieldInfo : BaseInfo {
		public FieldInfoFlags get_flags ();
		public int get_size ();
		public int get_offset ();
		public TypeInfo get_type ();

		public bool get_field (void* mem, out Argument value);
		public bool set_field (void* mem, ref Argument value);
	}

	[Compact]
	[CCode (cprefix = "g_union_info_")]
	public class UnionInfo : RegisteredTypeInfo {
		public int get_n_fields ();
		public FieldInfo get_field (int index);
		public int get_n_methods ();
		public FunctionInfo get_method (int index);
		public bool is_discriminated ();
		public int get_discriminator_offset ();
		public TypeInfo get_discriminator_type ();
		public ConstantInfo get_discriminator (int index);
		public FunctionInfo find_method (string name);
		public size_t get_size ();
		public size_t get_alignment ();
	}

	[Compact]
	[CCode (cprefix = "g_struct_info_")]
	public class StructInfo : RegisteredTypeInfo {
		public int get_n_fields ();
		public FieldInfo get_field (int index);
		public int get_n_methods ();
		public FunctionInfo get_method (int index);
		public FunctionInfo find_method (string name);
		public size_t get_size ();
		public size_t get_alignment ();
		public bool is_gtype_struct ();
	}

	[Compact]
	[CCode (cprefix = "g_registered_type_info_")]
	public class RegisteredTypeInfo : BaseInfo {
		public unowned string get_type_name ();
		public unowned string get_type_init ();
		public Type get_g_type ();
	}

	[Compact]
	[CCode (cprefix = "g_enum_info_")]
	public class EnumInfo : RegisteredTypeInfo {
		public int get_n_values ();
		public ValueInfo get_value (int index);
		public TypeTag get_storage_type ();
	}

	[Compact]
	[CCode (cprefix = "g_object_info_")]
	public class ObjectInfo : RegisteredTypeInfo {
		public unowned string get_type_name ();
		public unowned string get_type_init ();
		public bool get_abstract ();
		public ObjectInfo get_parent ();
		public int get_n_interfaces ();
		public InterfaceInfo get_interface (int index);
		public int get_n_fields ();
		public FieldInfo get_field (int index);
		public int get_n_properties ();
		public PropertyInfo get_property (int index);
		public int get_n_methods ();
		public FunctionInfo get_method (int index);
		public FunctionInfo find_method (string name);
		public int get_n_signals ();
		public SignalInfo get_signal (int index);
		public int get_n_vfuncs ();
		public VFuncInfo get_vfunc (int index);
		public VFuncInfo find_vfunc (string name);
		public int get_n_constants ();
		public ConstantInfo get_constant (int index);
		public StructInfo get_class_struct ();
	}

	[Compact]
	[CCode (cprefix = "g_interface_info_")]
	public class InterfaceInfo : RegisteredTypeInfo {
		public int get_n_prerequisites ();
		public BaseInfo get_prerequisite (int index);
		public int get_n_properties ();
		public PropertyInfo get_property (int index);
		public int get_n_methods ();
		public FunctionInfo get_method (int index);
		public FunctionInfo find_method(string name);
		public int get_n_signals ();
		public SignalInfo get_signal (int index);
		public int get_n_vfuncs ();
		public VFuncInfo get_vfunc (int index);
		public VFuncInfo find_vfunc (string name);
		public int get_n_constants ();
		public ConstantInfo get_constant (int index);
		public StructInfo get_iface_struct ();
	}

	[Compact]
	[CCode (cprefix = "g_property_info_")]
	public class PropertyInfo : BaseInfo {
		public ParamFlags get_flags ();
		public TypeInfo get_type ();
	}

	[Compact]
	[CCode (cprefix = "g_signal_info_")]
	public class SignalInfo : CallableInfo {
		public SignalFlags get_flags ();
		public VFuncInfo get_class_closure (int index);
		public bool true_stops_emit ();
	}

	[Flags]
	[CCode (cprefix = "GI_VFUNC_")]
	public enum VFuncInfoFlags {
		MUST_CHAIN_UP,
		MUST_OVERRIDE,
		MUST_NOT_OVERRIDE
	}

	[Compact]
	[CCode (cprefix = "g_vfunc_info_")]
	public class VFuncInfo : CallableInfo {
		public VFuncInfoFlags get_flags ();
		public FunctionInfo? get_invoker ();
		public int get_offset ();
		public SignalInfo? get_signal ();
	}

	[Compact]
	[CCode (cprefix = "g_constant_info_")]
	public class ConstantInfo : BaseInfo {
		public TypeInfo get_type ();
		public int get_value (out Argument value);
	}
}
