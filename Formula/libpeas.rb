class Libpeas < Formula
  desc "GObject plugin library"
  homepage "https://wiki.gnome.org/Projects/Libpeas"
  url "https://download.gnome.org/sources/libpeas/1.34/libpeas-1.34.0.tar.xz"
  sha256 "4305f715dab4b5ad3e8007daec316625e7065a94e63e25ef55eb1efb964a7bf0"
  license "LGPL-2.1-or-later"

  bottle do
    rebuild 1
    sha256 arm64_ventura:  "6c55f3faba5fd8041d403af6746948ce644ecd642fdec395c1864c8fb6cc1b6b"
    sha256 arm64_monterey: "ae9194d2a8ed9a6a73b67f2c335013bc1c92fac1dc07df1b14786ac45724a5f6"
    sha256 arm64_big_sur:  "d75fd0e883aa0871286a6bb92e538fc14aa52a26fe301d9322a4228340abdd74"
    sha256 ventura:        "91dd8fe4c9b107fd84ad77b060fec01cdfaea39325035e1cd68061d102d3accc"
    sha256 monterey:       "f49b5722a67a59138d7eead6bccfd6ccbff5b874467e0c7afb1c96816ddf63c1"
    sha256 big_sur:        "228667efcb0e3f0e2a78a96a882cdecf63f2c8632e93a75a241e05b9a70aedb7"
    sha256 x86_64_linux:   "b7879166a232ddb8b0cfe5080e440e86b47179e6a920e3f1d40fb44e0a54e54f"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "vala" => :build
  depends_on "glib"
  depends_on "gobject-introspection"
  depends_on "gtk+3"
  depends_on "pygobject3"
  depends_on "python@3.11"

  def install
    args = %w[
      -Dpython3=true
      -Dintrospection=true
      -Dvapi=true
      -Dwidgetry=true
      -Ddemos=false
    ]

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <libpeas/peas.h>

      int main(int argc, char *argv[]) {
        PeasObjectModule *mod = peas_object_module_new("test", "test", FALSE);
        return 0;
      }
    EOS
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    gobject_introspection = Formula["gobject-introspection"]
    libffi = Formula["libffi"]
    flags = %W[
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{gobject_introspection.opt_include}/gobject-introspection-1.0
      -I#{include}/libpeas-1.0
      -I#{libffi.opt_lib}/libffi-3.0.13/include
      -D_REENTRANT
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{gobject_introspection.opt_lib}
      -L#{lib}
      -lgio-2.0
      -lgirepository-1.0
      -lglib-2.0
      -lgmodule-2.0
      -lgobject-2.0
      -lpeas-1.0
    ]
    flags << "-lintl" if OS.mac?
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
