%define build_timestamp %(date +"%Y%m%d%H%M")

Name:           valadate
Version:        2.0
Release:        2%{?dist}.%{build_timestamp}
Summary:        Valadate

License:        LGPL-2.0+
URL:            https://github.com/valadate-project/valadate
Group:          Development/Tools
Packager:       Jenkins User <jenkins@valadate.org>
Source0:        valadate.tar.gz

BuildRequires:  libtool

%description
For Vala developers who need to test their code, Valadate is a powerful
testing framework that provides behavioral, functional and unit testing
features to help them write great Open Source software. Unlike other testing
frameworks, Valadate is designed especially for Vala while integrating
seamlessly into existing toolchains.


%check
make check


%prep
%setup -q
./autogen.sh

%build
%configure
make %{?_smp_mflags}


%install
rm -rf $RPM_BUILD_ROOT
%make_install


%files
%doc README.md COPYING
%{_libdir}/*
%{_datadir}/*
%{_includedir}/*

%changelog
* Wed Apr 5 2017 Chris Daley <chebizarro@gmail.com> - 2.0.0-1
- RPM release
* Tue Feb 23 2016 Chris Daley <chebizarro@gmail.com> - 1.0.0-1
- Initial RPM release
