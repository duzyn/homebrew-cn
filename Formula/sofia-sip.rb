class SofiaSip < Formula
  desc "SIP User-Agent library"
  homepage "https://sofia-sip.sourceforge.io/"
  url "https://github.com/freeswitch/sofia-sip/archive/v1.13.10.tar.gz"
  sha256 "5840eb3474f302a013cf2dc5a79ebef8c07437d62e5ef81ef6093652a5596adb"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "2386783f06882d5aadd2410a7a71ee7a3c26c1713be28bd7f7d4249360fe63cd"
    sha256 cellar: :any,                 arm64_monterey: "1dd9c19cb2b957bfe767c4d317ada6fa1b80432070359e9f20e1762fca290f68"
    sha256 cellar: :any,                 arm64_big_sur:  "ab3176389c1f03030bc349bdfb13ee2d20fbe9dab35d7ded0ede8068cfb36223"
    sha256 cellar: :any,                 ventura:        "7a0b21114ec6db4f05153ed04a6963439599587e680d265a7d41885f9703789a"
    sha256 cellar: :any,                 monterey:       "e676b1a8e2cc78a1f0925dbb29e7e1458b21301f3f72c0228b0acc609b14d2f7"
    sha256 cellar: :any,                 big_sur:        "3f7da997ad3eacef9a436506e5e3095cec96e84cf1714c9bbadb57426be05f03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c9214e97957b3d4750d0d01fcfec9396996e866ebdb652808971d52de6dfb798"
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
