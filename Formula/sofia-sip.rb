class SofiaSip < Formula
  desc "SIP User-Agent library"
  homepage "https://sofia-sip.sourceforge.io/"
  url "https://github.com/freeswitch/sofia-sip/archive/v1.13.11.tar.gz"
  sha256 "aaebd6b480ab8fa56e02eea2d33272d8a8fc49257b1b94daa7033569f50acc6c"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "378f0e53eb0f67c808b1b945db49395b5ef7b7c45db426967b338fdad92431de"
    sha256 cellar: :any,                 arm64_monterey: "b751275b9e9fbfcef6467f71a5cba21f0a76922165b046151c174a7a0f2635c3"
    sha256 cellar: :any,                 arm64_big_sur:  "0979e6efa9d99a3691989053be95ef021ee3c659b3f685ee9f64c74edb0b07db"
    sha256 cellar: :any,                 ventura:        "274ff84113b56b98ad53ab8259d53aa5e30500093051fd23140dc517dcf0e7ae"
    sha256 cellar: :any,                 monterey:       "ea70cb7f1679bd062d89d016141b5679d74210d9aa3bd0ceb26a5a054dcb222b"
    sha256 cellar: :any,                 big_sur:        "7d8a534f02df4040a2bb526484e2186dbb1bb8ec877a1b224468660882b5f8e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "94c87ea1757270244b39dfab0f6b9d7f7436d576dec8e090c0f84a5957032de8"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "openssl@1.1"

  def install
    system "./bootstrap.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/localinfo"
    system "#{bin}/sip-date"
  end
end
