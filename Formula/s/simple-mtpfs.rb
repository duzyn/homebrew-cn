class SimpleMtpfs < Formula
  desc "Simple MTP fuse filesystem driver"
  homepage "https://github.com/phatina/simple-mtpfs"
  url "https://mirror.ghproxy.com/https://github.com/phatina/simple-mtpfs/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "1d011df3fa09ad0a5c09d48d84c03e6cddf86390af9eb4e0c178193f32f0e2fc"
  license "GPL-2.0-or-later"

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, x86_64_linux: "c194161a8dbd1095e449cceb1b21e7e64f68d6541ab32c63ff78092260df8d49"
  end

  depends_on "autoconf" => :build
  depends_on "autoconf-archive" => :build # required for AX_CXX_COMPILE_STDCXX_17
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "libfuse@2"
  depends_on "libmtp"
  depends_on :linux # on macOS, requires closed-source macFUSE

  fails_with gcc: "5"

  def install
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}",
      "CPPFLAGS=-I/usr/local/include/osxfuse -I/usr/local/include/osxfuse/fuse",
      "LDFLAGS=-L/usr/local/include/osxfuse"
    system "make"
    system "make", "install"
  end

  test do
    system bin/"simple-mtpfs", "-h"
  end
end
