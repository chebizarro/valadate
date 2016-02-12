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

namespace Valadate {

	public delegate Type CreateTest();
	public delegate Object CreateTestObject();
	public delegate void TestMethod(TestCase self);

	public int main (string[] args) {
	
		foreach (string arg in args)
			message (arg);

		var modname = args[0].replace("lt-",""); // GLib.Environment.get_current_dir() + "/" + args[0].replace(".libs/","");

		GLib.Test.init (ref args);
		
		var mod = Module.open (modname, ModuleFlags.BIND_LOCAL);
		/*
		if(mod == null) {
			modname = args[0];
			mod = Module.open (modname, ModuleFlags.BIND_LAZY);
		}*/
		debug(Module.error());
		assert (mod != null);
		//mod.make_resident();
		
		var gir = modname.replace(".libs/","") + "-0.gir";
		
		Xml.Doc* doc = Xml.Parser.parse_file (gir);
		if (doc == null) {
			debug ("File not found\n");
			return 0;
		}

		string ns = "'http://www.gtk.org/introspection/core/1.0'";
		string xpath = @"//*[local-name()='class' and namespace-uri()=$ns and @parent='Valadate.TestCase']";
		xpath += @"/*[local-name()='constructor' and namespace-uri()=$ns]";
		Xml.XPath.Context cntx = new Xml.XPath.Context (doc);
		Xml.XPath.Object* res = cntx.eval_expression (xpath);

		assert (res != null);
		assert (res->type == Xml.XPath.ObjectType.NODESET);
		assert (res->nodesetval != null);
		assert (res->nodesetval->length() > 0);

		for (int i = 0; i < res->nodesetval->length (); i++) {
			Xml.Node* node = res->nodesetval->item (i);
			var gtype = node->get_prop("identifier");
			debug(gtype);
			void* function;
			assert(mod.symbol (gtype, out function));
			//mod.symbol (gtype, out function);
			debug(Module.error());
			assert(function != null);
			CreateTestObject create = (CreateTestObject)function;

			var testcase = create();
			Valadate.TestCase test = testcase as Valadate.TestCase;
			assert(test != null);

			Xml.Node* func = node->parent->children;
			assert(func != null);
			while(func != null) {
				debug(func->name);
				if (func->name == "function" || func->name == "method") {
					if(func->children != null) {
						Xml.Node* meth = func->children;
						debug(meth->name);
						while (meth != null) {
							if(meth->get_prop("key") == "test.name") {
								var funcname = func->get_prop("identifier");
								debug(funcname);
								void* test_function;
								assert(mod.symbol (funcname, out test_function));
								assert(function != null);
								var method = (TestMethod)function;
								test.add_test(funcname, ()=> {method(test); });
							}
							meth = meth->next;
						}
					}
				}
				func = func->next;
			}
		


			var suite = test.suite;
			GLib.TestSuite.get_root().add_suite(suite);
			
		}

		delete res;
		delete doc;
		
		GLib.Test.run ();
		return 0;
	}

}
