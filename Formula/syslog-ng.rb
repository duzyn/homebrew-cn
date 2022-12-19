class SyslogNg < Formula
  desc "Log daemon with advanced processing pipeline and a wide range of I/O methods"
  homepage "https://www.syslog-ng.com"
  url "https://ghproxy.com/github.com/syslog-ng/syslog-ng/releases/download/syslog-ng-3.38.1/syslog-ng-3.38.1.tar.gz"
  sha256 "5491f686d0b829b69b2e0fc0d66a62f51991aafaee005475bfa38fab399441f7"
  license all_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]
  revision 1

  bottle do
    sha256 arm64_ventura:  "5c5183c1ae96ae26524f78a90219c8dafb35ae7eb5d7968c33e68cfa58940f91"
    sha256 arm64_monterey: "e16a1658df491f7e107da9f6fae05e8d71969e105deff4fcdaab7b3b32b2471b"
    sha256 arm64_big_sur:  "8faee7351f56f372ab4a3bc0bc194f26c8a6731cc373d6aee7ecdce93b47d9c9"
    sha256 ventura:        "8b1b13f07de319fcd6efe0e23f7be97451b716f7703871fa0acb7e120fee1a42"
    sha256 monterey:       "dbbf52030649f1a75517259055d4ea40efbb2675fce09fee16420b84cda5115b"
    sha256 big_sur:        "d4dc9db2d912a890d6759de2288137604eb523dfc73c187d49543cb2c20f8b0e"
    sha256 x86_64_linux:   "815cf738e4ab69828a7c112ad19514fd57e72bbf8b968b8c99b75d7cd62736d3"
  end

  depends_on "autoconf" => :build
  depends_on "autoconf-archive" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  depends_on "glib"
  depends_on "hiredis"
  depends_on "ivykis"
  depends_on "json-c"
  depends_on "libdbi"
  depends_on "libmaxminddb"
  depends_on "libnet"
  depends_on "librdkafka"
  depends_on "mongo-c-driver"
  depends_on "openssl@1.1"
  depends_on "pcre"
  depends_on "python@3.11"
  depends_on "riemann-client"

  uses_from_macos "curl"

  def install
    sng_python_ver = Formula["python@3.11"].version.major_minor

    system "./configure", *std_configure_args,
                          "--disable-silent-rules",
                          "--sysconfdir=#{pkgetc}",
                          "--localstatedir=#{var}",
                          "--with-ivykis=system",
                          "--with-python=#{sng_python_ver}",
                          "--disable-afsnmp",
                          "--disable-java",
                          "--disable-java-modules"
    system "make", "install"
  end

  test do
    system "#{sbin}/syslog-ng", "--version"
    system "#{sbin}/syslog-ng", "--cfgfile=#{pkgetc}/syslog-ng.conf", "--syntax-only"
  end
end
