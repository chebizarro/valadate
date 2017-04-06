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

	public abstract class Program : Object, Assembly {
	
		public File binary {get;set;}

		protected static SubprocessLauncher launcher;

		class construct {
			launcher = new SubprocessLauncher(
				GLib.SubprocessFlags.STDOUT_PIPE |
				GLib.SubprocessFlags.STDERR_MERGE);
		}
		
		public Program(File binary) {
			this.binary = binary;
		}

		public virtual void run(string? command = null) throws Error {
			string[] args;
			Shell.parse_argv("%s %s".printf(program.get_path(), command ?? ""), out args);
			string buffer = null;
			var process = launcher.spawnv(args);
			process.communicate_utf8(null, null, out buffer, null);

			try {
				if(process.wait_check()) {
					//callback(false, buffer);
				}
			} catch (Error e) {
				//callback(true, buffer);
			}
		}

		//public abstract void run();
		public void* get_method(string method_name) throws AssemblyError {
			return null;
		}

	}
}
