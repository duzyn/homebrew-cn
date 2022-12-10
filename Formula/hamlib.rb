class Hamlib < Formula
  desc "Ham radio control libraries"
  homepage "http://www.hamlib.org/"
  url "https://ghproxy.com/github.com/Hamlib/Hamlib/releases/download/4.5.1/hamlib-4.5.1.tar.gz"
  sha256 "acdaf2f91c052e17276b06b9170a03f929600763caaf94a6377e1a906cd631c8"
  license "LGPL-2.1-or-later"
  head "https://github.com/hamlib/hamlib.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "6b3f5c3de2eb976b5de08fd88326c07c18adb78db0d8a663fe355f9a4fa24560"
    sha256 cellar: :any,                 arm64_monterey: "0222785bb86a7d66c5f10df85394fdbc0389e80786dc842adb3d4522d4d576ab"
    sha256 cellar: :any,                 arm64_big_sur:  "7edf9b856a4d1180961ecb1242781fa0c14d53647007a9f63180423e2dec473d"
    sha256 cellar: :any,                 ventura:        "86d5d653277ed201c52fb9848fc6d37b8de467b024cfc9255af2fc97b772b1d9"
    sha256 cellar: :any,                 monterey:       "7458875e8171f179b5dde20f4f1e1f46e9531978540bf51c1245c912df53ca1a"
    sha256 cellar: :any,                 big_sur:        "7a246316ebe664390effd6519a2ada4f9e55d9df8c4f7b7bde624718b1db2dd6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b53695adeb15a44ebd5b732aaaf98f0575f150d797f57a1ad7ab04cc5ea26496"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "libtool"
  depends_on "libusb-compat"

  fails_with gcc: "5"

  def install
    system "./bootstrap" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/rigctl", "-V"
  end
end
