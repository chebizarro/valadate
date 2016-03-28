namespace Xslt {

	[Compact]
	[CCode (cname="xsltStylesheet", free_function="xsltFreeStylesheet", cheader_filename="libxslt/xsltInternals.h")]
	public class Stylesheet {
	
		[CCode (cname="xsltApplyStylesheet", cheader_filename="libxslt/transform.h")]
		public Xml.Doc* apply(Xml.Doc *doc, [CCode (array_null_terminated=true, array_length=false)] string[] parameters);
		
		[CCode (cname="xsltSaveResultToString", instance_pos=4, cheader_filename="libxslt/xsltutils.h")]
		public int save_result_to_string(out string doc_txt_ptr, out int doc_txt_len, Xml.Doc *result);
	}
	
	[CCode (cname="xsltParseStylesheetFile", cheader_filename="libxslt/xsltInternals.h")]
	public static Xslt.Stylesheet* parse_stylesheet_file(string filename);

	[CCode (cname="xsltParseStylesheetDoc", cheader_filename="libxslt/xsltInternals.h")]
	public static Xslt.Stylesheet* parse_stylesheet_doc(Xml.Doc *doc);

}
