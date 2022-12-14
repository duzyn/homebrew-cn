class Haproxy < Formula
  desc "Reliable, high performance TCP/HTTP load balancer"
  homepage "https://www.haproxy.org/"
  url "https://www.haproxy.org/download/2.7/src/haproxy-2.7.0.tar.gz"
  sha256 "0f7bdebd9b0d7abfd89087bf36af6bd1520d3234266349786654e32e186b4768"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }

  livecheck do
    url :homepage
    regex(/href=.*?haproxy[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "8023bee5a29f2701c1f41c83c69cab61633b9014bd37821bbe87fb2843e4e2a9"
    sha256 cellar: :any,                 arm64_monterey: "51068e8ed65711f87cf7d48eda36c8cc68a3a3e5716edcc4b73e70c4fa69217a"
    sha256 cellar: :any,                 arm64_big_sur:  "f3fab924433fbc04c94728c0cdc0d46ce188e288225b66d1ff94c6cc3a254aa5"
    sha256 cellar: :any,                 ventura:        "4ff58a45a1ee44666c0b11f89f3ff03c8ac3f7f2f5b3c8c78d72829cf4a36167"
    sha256 cellar: :any,                 monterey:       "bc29696dc106a37d9e402ecd1cf29e5931978066c83057a4421adf5c4f9553eb"
    sha256 cellar: :any,                 big_sur:        "0732598694cd3261f5418dd34539b67214cb8c2e2c83ce9468af0ea3d566a9e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "96fff3f1ee61aa5d5b3c5e3200f1f79bcb46e2b2232b9ace0cc1eb80e57ec6aa"
  end

  depends_on "openssl@3"
  depends_on "pcre2"

  uses_from_macos "libxcrypt"
  uses_from_macos "zlib"

  def install
    args = %w[
      USE_PCRE2=1
      USE_PCRE2_JIT=1
      USE_OPENSSL=1
      USE_ZLIB=1
    ]

    target = if OS.mac?
      "osx"
    else
      "linux-glibc"
    end
    args << "TARGET=#{target}"

    # We build generic since the Makefile.osx doesn't appear to work
    system "make", *args
    man1.install "doc/haproxy.1"
    bin.install "haproxy"
  end

  service do
    run [opt_bin/"haproxy", "-f", etc/"haproxy.cfg"]
    keep_alive true
    log_path var/"log/haproxy.log"
    error_log_path var/"log/haproxy.log"
  end

  test do
    system bin/"haproxy", "-v"
  end
end
