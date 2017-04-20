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

	public class SystemProgram : Assembly {

		private string name;
	
		public SystemProgram(string name) throws Error {
			base(File.new_for_path(Environment.find_program_in_path(name)));
			this.name = name;
		}

		public override Assembly clone() {
			return new SystemProgram(name);
		}

		public virtual Assembly pipe(string? command = null, InputStream input, Cancellable? cancellable = null) throws Error {
			string[] args;
			Shell.parse_argv("%s %s".printf(binary.get_path(), command ?? ""), out args);
			process = launcher.spawnv(args);
			stdout = new DataInputStream (process.get_stdout_pipe());
			stderr = new DataInputStream (process.get_stderr_pipe());
			stdin = new DataOutputStream (process.get_stdin_pipe());
			stdin.splice(input, OutputStreamSpliceFlags.CLOSE_TARGET);
			process.wait_check(cancellable);
			cancellable.set_error_if_cancelled();
			return this;
		}



	}
}
