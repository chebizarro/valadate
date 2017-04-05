# Documentation: https://github.com/Homebrew/homebrew/blob/master/share/doc/homebrew/Formula-Cookbook.md
#                http://www.rubydoc.info/github/Homebrew/homebrew/master/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class Valadate < Formula
  desc ""
  homepage "https://github.com/valadate-project/valadate"
  url "https://codeload.github.com/valadate-project/valadate/tar.gz/master"
  sha256 "4f3e55cb9726f174331b90ebcc7b63484734952df8f87e6a35ec4162178095d8"
  version "1.0.0"

  depends_on "libtool" => :build
  depends_on "automake" => :build
  depends_on "autoconf" => :build
  depends_on "vala" => :build

  depends_on "glib"
  depends_on "libxml2"
  depends_on "json-glib"
  depends_on "libxslt"


  depends_on :x11 # if your formula requires any X11/XQuartz components

  def install
    system "autoreconf"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--enable-installed-tests"
    system "make", "install"
  end

  test do
    system "/usr/local/libexec/installed-tests/Valadate/./tests_libvaladate"
  end
end
