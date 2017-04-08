/*
 * Valadate - Unit testing library for GObject-based libraries.
 * Copyright (C) 2017  Chris Daley <chebizarro@gmail.com>
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

	public enum TestStatus {
		NOT_RUN,
		RUNNING,
		PASSED,
		SKIPPED,
		TODO,
		ERROR,
		FAILED,
		STATUS
	}

	public abstract class TestMessage {
		public string level {get;set;}
		public string message {get;set;}
		public string? file {get;set;}
		public string? line {get;set;}
		public string? function {get;set;}
		
		public TestMessage(string level, string message, string? path = null) {
			this.level = level;
			this.message = message;
			
			if(path != null) {
				var paths = path.split(":");
				if(paths.length >= 2) {
					this.file = paths[0];
					this.line = paths[1];
					if(paths.length >= 3)
						this.function = paths[2];
				}
			}
		}
		
		public virtual string to_string() {
			if(file != null)
				return "%s : %s:%s: %s".printf(
					level, file, 
					(function != null) ? "%s:%s".printf(line, function) :
					line,
					message);
			else
				return "%s : %s".printf(level, message);
		}
	}

	public class TestReport {

		//public signal void report(TestStatus status);
		
		public Test test {get;set;}
		
		public int index {get;set;}
		
		public TestMessage? error {get;set;}

		private List<TestMessage> _messages = new List<TestMessage>();
		
		public List<TestMessage> messages {
			get { return _messages;	}
		}
		
		public string? buffer {get;set;}
		
		public TestReport(Test test, TestStatus status, int index) {
			this.test = test;
			//this.status = status;
			this.index = index;
		}
		
		public void report(OutputStream stream) throws Error {
			//if(
			
		}
		
	}
}
