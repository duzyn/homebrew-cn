class Libgtop < Formula
  desc "Library for portably obtaining information about processes"
  homepage "https://gitlab.gnome.org/GNOME/libgtop"
  url "https://download.gnome.org/sources/libgtop/2.40/libgtop-2.40.0.tar.xz"
  sha256 "78f3274c0c79c434c03655c1b35edf7b95ec0421430897fb1345a98a265ed2d4"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    rebuild 2
    sha256 arm64_sonoma:   "70be94bdf1f981d45870143f0d93cca108a8c2a21da4530433edb0c0191d0829"
    sha256 arm64_ventura:  "7ec6391d407997898f52778846034783e0d1f8fd88c3c5dce7e31fa7a7c9214a"
    sha256 arm64_monterey: "efd17d53f38b17e4dbce28b8ce2b47cb3f832010107b44800f16f109eca55929"
    sha256 arm64_big_sur:  "1b03ee2aee7281a673eff7004f5141e4077e0dfbd2e1ce31a9590fb1f3fc221c"
    sha256 sonoma:         "337d36977c59d423acfbf3fd0bc258069f50b80eb4a3f537ae006e5cc42cf948"
    sha256 ventura:        "ead43b0acfd3e16e8075e97d6e20809103058a8e56d0558353eb6da6b9487d62"
    sha256 monterey:       "96b3327e8a7cce44d856f6a2968512ad75a121901378ef5bdff0530999dd42c2"
    sha256 big_sur:        "e749a43ebcc150fba221570873bb6df8765eedd1719ad7080dbbb84b809b477d"
    sha256 catalina:       "9946efd963f1911a13a57d684d9b441ce804777711cfb88fc48fdcf55e6ba620"
    sha256 mojave:         "9a219f60e6ad45d0c4c01e3477789ea27a54595fdc16751f3b964d4cfb56fc3a"
    sha256 x86_64_linux:   "e397a31d868662a5cdc37e9c4f6dba1557a0f6d07d76c212f7ccf5775b7a70a3"
  end

  depends_on "gobject-introspection" => :build
  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "libxau"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--without-x"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <glibtop/sysinfo.h>

      int main(int argc, char *argv[]) {
        const glibtop_sysinfo *info = glibtop_get_sysinfo();
        return 0;
      }
    EOS
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    flags = %W[
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{include}/libgtop-2.0
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{lib}
      -lglib-2.0
      -lgtop-2.0
    ]
    flags << "-lintl" if OS.mac?
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
