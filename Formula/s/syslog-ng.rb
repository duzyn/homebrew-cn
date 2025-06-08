class SyslogNg < Formula
  include Language::Python::Virtualenv

  desc "Log daemon with advanced processing pipeline and a wide range of I/O methods"
  homepage "https://www.syslog-ng.com"
  url "https://mirror.ghproxy.com/https://github.com/syslog-ng/syslog-ng/releases/download/syslog-ng-4.8.3/syslog-ng-4.8.3.tar.gz"
  sha256 "f82732a8e639373037d2b69c0e6d5d6594290f0350350f7a146af4cd8ab9e2c7"
  license all_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]
  revision 1
  head "https://github.com/syslog-ng/syslog-ng.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sequoia: "094485d26ff9599881e5b0c0d4e984695979116fc1f5228688d9c4e9520fde5e"
    sha256 arm64_sonoma:  "98a0f77fb50272f195223c1b089e15b3c929a2577bda4e75d1dbda92fc7fc1b2"
    sha256 arm64_ventura: "381076b590c3df58a7bfcfa6e2eed2a9ad8165258ad3b2284a793e81ea7b3193"
    sha256 sonoma:        "6393121980490edeaaf60931d484233c7290c98421627703723deda5e5d4ea32"
    sha256 ventura:       "d6204352ea92e05f90fcafe91354b73310adf6d4565bcc77780526346ab7f5f4"
    sha256 arm64_linux:   "d2bbd7f1a3464f0eeb3286d540e5ec56c4aa8fcbd2ce1b148bf3e6e699ec2e9b"
    sha256 x86_64_linux:  "82e4c9098823597427bc2e259e0f28f4db17fa68524aca60d2677881b2e7237c"
  end

  depends_on "pkgconf" => :build

  depends_on "abseil"
  depends_on "glib"
  depends_on "grpc"
  depends_on "hiredis"
  depends_on "ivykis"
  depends_on "json-c"
  depends_on "libdbi"
  depends_on "libmaxminddb"
  depends_on "libnet"
  depends_on "libpaho-mqtt"
  depends_on "librdkafka"
  depends_on "mongo-c-driver@1"
  depends_on "net-snmp"
  depends_on "openssl@3"
  depends_on "pcre2"
  depends_on "protobuf"
  depends_on "python@3.12"
  depends_on "rabbitmq-c"
  depends_on "riemann-client"

  uses_from_macos "curl"

  on_macos do
    depends_on "gettext"
  end

  def install
    ENV["VERSION"] = version

    python3 = "python3.12"
    venv = virtualenv_create(libexec, python3)
    # FIXME: we should use resource blocks but there is no upstream pip support besides this requirements.txt
    # https://github.com/syslog-ng/syslog-ng/blob/master/requirements.txt
    args = std_pip_args(prefix: false, build_isolation: true).reject { |s| s["--no-deps"] }
    system python3, "-m", "pip", "--python=#{venv.root}/bin/python",
                          "install", *args, "--requirement=#{buildpath}/requirements.txt"

    system "./configure", *std_configure_args,
                          "CXXFLAGS=-std=c++17",
                          "--disable-silent-rules",
                          "--enable-all-modules",
                          "--sysconfdir=#{pkgetc}",
                          "--localstatedir=#{var/name}",
                          "--with-ivykis=system",
                          "--with-python=#{Language::Python.major_minor_version python3}",
                          "--with-python-venv-dir=#{venv.root}",
                          "--disable-example-modules",
                          "--disable-java",
                          "--disable-java-modules",
                          "--disable-smtp"
    system "make", "install"
  end

  test do
    output = shell_output("#{sbin}/syslog-ng --version")
    assert_equal "syslog-ng #{version.major} (#{version})", output.lines.first.chomp
    system sbin/"syslog-ng", "--cfgfile=#{pkgetc}/syslog-ng.conf", "--syntax-only"
  end
end
