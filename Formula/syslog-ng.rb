class SyslogNg < Formula
  desc "Log daemon with advanced processing pipeline and a wide range of I/O methods"
  homepage "https://www.syslog-ng.com"
  url "https://ghproxy.com/github.com/syslog-ng/syslog-ng/releases/download/syslog-ng-4.0.0/syslog-ng-4.0.0.tar.gz"
  sha256 "611ce47fe60b0d0608e5f642b395e265ffb884efc090bf427eb7d959ebec977d"
  license all_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]

  bottle do
    sha256 arm64_ventura:  "d25983d000210b55df9fd562dbba169871259f888b5194d348d3c7d35f531a81"
    sha256 arm64_monterey: "a5a8c879f3d4cc5cf70ba90a8ee26d7a693408b1caf590e99bcc807e0e48edf7"
    sha256 arm64_big_sur:  "f4e782e7625a6c98a6ac4663ba2e2ac4dd56c6e74af47dc8b4fdb365e4e4f92f"
    sha256 ventura:        "3dfd7a74674b74424ead1ed978352b6948e5e3b4e667f1c909f3fc74879d4131"
    sha256 monterey:       "944c89599d283d5146c7a24bbbbbe77bec76fd2bbdf8d3a9704a5da8d7316381"
    sha256 big_sur:        "11d53aeb0c8bca54f8fbd3716b26fe31af49dc56ece437d08dc3807bed4f1a5d"
    sha256 x86_64_linux:   "2833e0eaa0b46d375482830f578a1d8c5fcf8d137ec73f9436deaf4a424f231e"
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
