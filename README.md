Valadate
========

> For Vala developers who need to test their code, Valadate is a powerful testing framework that provides behavioral, functional and unit testing features to help them write great Open Source software. Unlike other testing frameworks, Valadate is designed especially for Vala while integrating seamlessly into existing toolchains.

[![Stories in Ready](https://badge.waffle.io/chebizarro/valadate.png?label=ready&title=Ready)](https://waffle.io/chebizarro/valadate)

[![Build Status](http://jenkins.valadate.org:8080/buildStatus/icon?job=Valadate-1.0.0)](http://jenkins.valadate.org:8080/job/Valadate-1.0.0/)

This project adheres to the [Open Code of Conduct][code-of-conduct]. By participating, you are expected to honor this code.
[code-of-conduct]: http://todogroup.org/opencodeofconduct/#Valadate/chebizarro@gmail.com

You can follow Valadate's development [here](http://bit.ly/1UDpayV).

To build
```
./autogen.sh
make
```

To run the unit tests
```
make check
```

## Planned Features

  * Extensive documentation and sample projects
  
  * Automatic test discovery like JUnit or .NET testing framework.

  * Running tests for all parameters from specific set.

  * Utility functions for waiting in a main loop until specified event or
    timeout occurs.

  * Support for asynchronous tests.

  * Utility functions providing temporary directory to tests.

  * Automatically running each test in a separate child process.

  * Running next tests even after failure.

  * Skipped tests and expected failures.

  * Initializing test directories by extracting zip and/or tar.gz
    archives.

  * Generic tests.

## Dependencies


  * [GLib][glib] 2.40.0 or later
  * [Vala][vala] 0.30.0 or later
  * [GOjbect-introspection][gir] 1.0.0 or later

## Copyright

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Lesser General Public License as published
by the Free Software Foundation, either version 3 of the License, or (at
your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public License
along with this program in the file COPYING.  You should have received
a copy of the GNU General Public License refered therein along with this
program in the file GPL-3.  If not, see <http://www.gnu.org/licenses/>.

[vala]: https://wiki.gnome.org/Projects/Vala
[gir]: https://wiki.gnome.org/Projects/GObjectIntrospection
[glib]: https://wiki.gnome.org/Projects/GLib
