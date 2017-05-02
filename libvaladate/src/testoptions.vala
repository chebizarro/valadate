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

	public class TestOptions {

		private static string _format = "tap";
		private static bool _keepgoing = true;
		private static bool _list;
		private static int _timeout = 60000;
		private static bool _tap = true;
		private static string _running_test = null;
		private static string _seed;
		private static bool _version;
		private static string _path;

		public const OptionEntry[] options = {
			{ "format", 'f', 0, OptionArg.STRING, ref _format, "Output test results using format", "FORMAT" },
			{ "", 'k', 0, OptionArg.NONE, ref _keepgoing, "Skip failed tests and continue running", null },
			{ "list", 'l', 0, OptionArg.NONE, ref _list, "List test cases available in a test executable", null },
			{ "", 'r', 0, OptionArg.STRING, ref _running_test, null, null },
			{ "tap", 0, 0, OptionArg.NONE, ref _tap, "Output test results using TAP format" },
			{ "timeout", 't', 0, OptionArg.INT, ref _timeout, "Default timeout for tests", "MILLISECONDS" },
			{ "seed", 0, 0, OptionArg.STRING, ref _seed, "Start tests with random seed", "SEEDSTRING" },
			{ "version", 0, 0, OptionArg.NONE, ref _version, "Display version number", null },
			{ "path", 'p', 0, OptionArg.STRING, ref _path, "Only start test cases matching", "TESTPATH..." },
			{ null }
		};

		public OptionContext opt_context;

		public string format {
			get {
				return _format;
			}
		}

		public string seed {
			get {
				return _seed;
			}
		}

		public string? testpath {
			get {
				return _path;
			}
		}

		public string? running_test {
			get {
				return _running_test;
			}
		}

		public bool list {
			get {
				return _list;
			}
		}

		public bool keepgoing {
			get {
				return _keepgoing;
			}
		}

		public int timeout {
			get {
				return _timeout;
			}
		}

		public TestOptions(string[] args) throws OptionError {
			_running_test = null;

			opt_context = new OptionContext ("- Valadate Testing Framework");
			opt_context.set_help_enabled (true);
			opt_context.add_main_entries (options, null);
			opt_context.parse (ref args);

			if(_seed == null)
				_seed = "R02S%08x%08x%08x%08x".printf(
					GLib.Random.next_int(),
					GLib.Random.next_int(),
					GLib.Random.next_int(),
					GLib.Random.next_int());

		}

	}
}
