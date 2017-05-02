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

		// The run command must be run before the pip command
		// otherwise it will throw an error
		public virtual SystemProgram pipe(
			string? command = null,
			SystemProgram program,
			Cancellable? cancellable = null)
			throws Error {

			program.stdin.splice(stdout, OutputStreamSpliceFlags.CLOSE_TARGET);
			return this;
		}



	}
}
