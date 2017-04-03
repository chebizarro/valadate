/*
 * Valadate - Unit testing library for GObject-based libraries.
 * Copyright (C) 2016  Chris Daley <chebizarro@gmail.com>
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.

 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.

 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301  USA
 *
 * Authors:
 * 	Chris Daley <chebizarro@gmail.com>
 */
namespace Valadate {

	public errordomain ConfigError {
		MODULE,
		TESTPLAN,
		METHOD
	}

	public class TestConfig : Object {

		public TestOptions options {get;construct set;}

		public virtual string seed {
			get {
				return options.seed;
			}
		}

		public string running_test {
			get {
				return options.running_test;
			}
		}

		public virtual bool run_async {
			get {
				return options.run_async;
			}
		}

		public virtual bool list_only {
			get {
				return options.list;
			}
		}

		public virtual bool keep_going {
			get {
				return options.keepgoing;
			}
		}

		public virtual bool timed {
			get {
				return options.timed;
			}
		}

		public TestConfig(TestOptions options) {
			Object(options : options);
		}

		/*
		public int parse(string[] args) {
			try {
				opt_context.parse (ref args);
			} catch (OptionError e) {
				stdout.printf ("%s\n", e.message);
				stdout.printf ("Run '%s --help' to see a full list of available command line options.\n", args[0]);
				return 1;
			}

			if (version) {
				stdout.printf ("Valadate %s\n", "1.0");
				return 0;
			}
			
			return -1;
		}
		*/

	}

}
