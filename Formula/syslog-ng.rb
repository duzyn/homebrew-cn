class SyslogNg < Formula
  desc "Log daemon with advanced processing pipeline and a wide range of I/O methods"
  homepage "https://www.syslog-ng.com"
  url "https://ghproxy.com/github.com/syslog-ng/syslog-ng/releases/download/syslog-ng-3.38.1/syslog-ng-3.38.1.tar.gz"
  sha256 "5491f686d0b829b69b2e0fc0d66a62f51991aafaee005475bfa38fab399441f7"
  license all_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]

  bottle do
    sha256 arm64_ventura:  "675d1a2a2b70a6ba65300a2b79aa6fb0ca593dcdcffae7f029b4b65b516a5b97"
    sha256 arm64_monterey: "c5b183bdee146482748c0f73f4c57ae223ca3411091a09712cba45cc272a4d88"
    sha256 arm64_big_sur:  "f44ddd51a55cff76a51fcea4b280235b4a74f5377084d43987425b6f730e63d5"
    sha256 monterey:       "fccdba6100604e263d3be61e0a2355eda2520c27dcde94cc6b953ee457fcb842"
    sha256 big_sur:        "ac90f726c743e787eb3727618a53afc2350651057845609bbdea72568a3a5ed7"
    sha256 catalina:       "72fd2a1b438e832e604f8487637aa81b6f1f489f5b6aa1f7554e18902a4f3fa9"
    sha256 x86_64_linux:   "35d12e4a4b37549a947d1754aaad2f93c2a4b54aef4fd7e3266ccc90c526a114"
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
