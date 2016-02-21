## Arrange >> Act >> Assert with Valadate

For Vala developers who need to test their code, Valadate is a powerful testing framework that provides behavioral, functional and unit testing features to help them write great Open Source software. Unlike other testing frameworks, Valadate is designed especially for Vala while integrating seamlessly into existing toolchains.

[![Real example](https://github.com/chebizarro/valadate/wiki/images/valadate_screenshot.png)]()

## Status
Valadate is undergoing active development, the current stable version is 1.0.0.

| Platform | Status |
| --- | --- |
| Ubuntu  15.04 | [![Build Status](http://jenkins.valadate.org:8080/buildStatus/icon?job=Valadate-1.0.0)](http://jenkins.valadate.org:8080/job/Valadate-1.0.0/) |

## Current Features

  * Automatic test discovery like JUnit or .NET testing framework.

  * Utility functions for waiting in a main loop until specified event or
    timeout occurs.

  * Support for asynchronous tests.

  * Utility functions providing temporary directory to tests.

  * Skipped tests and expected failures.

### Usage

Valadate makes writing tests as simple as:

```vala
public class TestExe : TestCase {
	
	[Test (name="test_one")]
	public void test_one () {
		Assert.is_true(true);
	}

	[AsyncTest (name="test_async", timeout=1000)]
	public async void test_async () throws ThreadError {
		assert_true(true);
	}
	
}
```
See the [Wiki](https://github.com/chebizarro/valadate/wiki) for detailed instructions on installing and setting up your toolchain with Valadate.

## Follow

* [blog](http://bit.ly/1UDpayV)
* Waffle - [![Stories in Ready](https://badge.waffle.io/chebizarro/valadate.png?label=ready&title=Ready)](https://waffle.io/chebizarro/valadate)
* GitHub [Issues](https://github.com/chebizarro/valadate/issues)

## Code of Conduct

This project adheres to the [Open Code of Conduct][code-of-conduct]. By participating, you are expected to honor this code.
[code-of-conduct]: http://todogroup.org/opencodeofconduct/#Valadate/chebizarro@gmail.com

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
program in the file GPL-3.  If not, see <[http://www.gnu.org/licenses/](http://www.gnu.org/licenses/)>.
