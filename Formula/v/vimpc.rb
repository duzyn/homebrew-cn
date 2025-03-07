class Vimpc < Formula
  desc "Ncurses based mpd client with vi like key bindings"
  homepage "https://sourceforge.net/projects/vimpc/"
  url "https://mirror.ghproxy.com/https://github.com/boysetsfrog/vimpc/archive/refs/tags/v0.09.2.tar.gz"
  sha256 "caa772f984e35b1c2fbe0349bc9068fc00c17bcfcc0c596f818fa894cac035ce"
  license "GPL-3.0-or-later"
  head "https://github.com/boysetsfrog/vimpc.git", branch: "master"

  bottle do
    sha256 arm64_sequoia:  "d7224868acdc3f21753f66baf1e1a5631651da85e89d7885f49b48137d9a1e67"
    sha256 arm64_sonoma:   "08b6a0c50415af4361a442810e8d4fb190e64f123230087604359fd00b10e654"
    sha256 arm64_ventura:  "a738652b8bbf20ab0449d5eea600f10aa602d5d7a490324c17efe2961afbbce5"
    sha256 arm64_monterey: "80a71521b623830617733116cbce155ba0598dac8604c7e19438207946ec1406"
    sha256 arm64_big_sur:  "fcbb4aae0e232572c4d44a0d08b5a59500978e0c428480d74d00b244345b3527"
    sha256 sonoma:         "0d936d2061ea8086c97950031cdebef46aac8061bcf45e77d2d24dd610dc25ab"
    sha256 ventura:        "a3963e103150ade1c6470703d7071530d15c760921bd329ed12c77996cdd2755"
    sha256 monterey:       "7484bfac23ae149460ca6292a86c3b54860fd96edc08d5f27cf3f6f621acfced"
    sha256 big_sur:        "493ef1f2bc8c9f52f41de234816fd93eb886393006be2b3cea1de40ddc0419ca"
    sha256 catalina:       "c8d1936d4ff7a8b85de154b64e7f7a276b6265c703029cca7c2e56ee4ca32abd"
    sha256 mojave:         "83dd8968d8fc7830c2dc90db35441c01bd62c567b8d2749e00edba7ee7429487"
    sha256 high_sierra:    "d457ed5a1b85e88f721d7617753aee99a3a8ed17806b5925b6458c9fb9477423"
    sha256 sierra:         "af41091db0a875b5fa05d0b1cc969df649693f4ceb4e14b8cdd72a3b6527a741"
    sha256 x86_64_linux:   "e2a99a63aaa638c00b002546903cffd1f63a085856dd5e62235102caac000162"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build

  depends_on "libmpdclient"
  depends_on "pcre"
  depends_on "taglib"

  uses_from_macos "curl"
  uses_from_macos "ncurses"

  def install
    system "./autogen.sh"
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"vimpc", "-v"
  end
end
