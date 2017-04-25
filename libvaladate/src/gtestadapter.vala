/*
 * Valadate - Unit testing library for GObject-based libraries.
 * Copyright (C) 2017 Chris Daley <chebizarro@gmail.com>
 * 
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
 * MA 02110-1301, USA.
 * 
 * 
 */
 
namespace Valadate {

	public class GTestAdapter {
	
		public GTestAdapter(string[] args) {

			GLib.Test.init(ref args);

			var ttype = typeof(TestCase);
			
			foreach(var tctype in ttype.children()) {

				var newtest = Object.new(tctype) as TestCase;
				var suite = new GLib.TestSuite(newtest.name);
				
				foreach(var test in newtest)
					
					suite.add(new GLib.TestCase(
						test.name, newtest.set_up, (GLib.TestFixtureFunc)test.run, newtest.tear_down));

				GLib.TestSuite.get_root().add_suite(suite);
			}
		}
		
		public void run() {
			GLib.Test.run ();
		}
	
	}

}
