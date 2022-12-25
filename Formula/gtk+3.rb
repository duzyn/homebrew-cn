class Gtkx3 < Formula
  desc "Toolkit for creating graphical user interfaces"
  homepage "https://gtk.org/"
  url "https://download.gnome.org/sources/gtk+/3.24/gtk+-3.24.36.tar.xz"
  sha256 "27a6ef157743350c807ffea59baa1d70226dbede82a5e953ffd58ea6059fe691"
  license "LGPL-2.0-or-later"

  livecheck do
    url :stable
    regex(/gtk\+[._-](3\.([0-8]\d*?)?[02468](?:\.\d+)*?)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "233b597626c0c4af10455128c9323e73bc6e0835ee03ae38a7d9f615157752dc"
    sha256 arm64_monterey: "8985bf4ee0887fd07f78df26bcdd80cec0280a7d2b8407b725fc6d3e04e25aec"
    sha256 arm64_big_sur:  "c99875bd2e1b23da482e3c85637af5aa540538f5bb7cbb49624053c92e85b35d"
    sha256 ventura:        "8401dfa54a5864e0176162d3e10829f862797b883947a1ae7ff6b619a44958ea"
    sha256 monterey:       "44f8537761575ccfcee61140ad68f50b76362bbff562b48d1724b53725ac3985"
    sha256 big_sur:        "fcf1de89fd5090f9cf78b2e626ef0df714cab4341de811d095c030b18d362d55"
    sha256 x86_64_linux:   "00d244b6140a22a85d164659f389f3a0f44fb28e5c273c13731a27469fbf379c"
  end

  depends_on "docbook" => :build
  depends_on "docbook-xsl" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "atk"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gsettings-desktop-schemas"
  depends_on "hicolor-icon-theme"
  depends_on "libepoxy"
  depends_on "pango"

  uses_from_macos "libxslt" => :build # for xsltproc

  on_linux do
    depends_on "cmake" => :build
    depends_on "at-spi2-atk"
    depends_on "cairo"
    depends_on "iso-codes"
    depends_on "libxkbcommon"
    depends_on "wayland-protocols"
    depends_on "xorgproto"

    # fix ERROR: Non-existent build file 'gdk/wayland/cursor/meson.build'
    # upstream commit reference, https://gitlab.gnome.org/GNOME/gtk/-/commit/66a19980
    # remove in next release
    patch :DATA
  end

  def install
    args = std_meson_args + %w[
      -Dgtk_doc=false
      -Dman=true
      -Dintrospection=true
    ]

    if OS.mac?
      args << "-Dquartz_backend=true"
      args << "-Dx11_backend=false"
    end

    # ensure that we don't run the meson post install script
    ENV["DESTDIR"] = "/"

    # Find our docbook catalog
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"

    mkdir "build" do
      system "meson", *args, ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end

    # Prevent a conflict between this and Gtk+2
    mv bin/"gtk-update-icon-cache", bin/"gtk3-update-icon-cache"
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
    system bin/"gtk3-update-icon-cache", "-f", "-t", "#{HOMEBREW_PREFIX}/share/icons/hicolor"
    system "#{bin}/gtk-query-immodules-3.0 > #{HOMEBREW_PREFIX}/lib/gtk-3.0/3.0.0/immodules.cache"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <gtk/gtk.h>

      int main(int argc, char *argv[]) {
        gtk_disable_setlocale();
        return 0;
      }
    EOS
    atk = Formula["atk"]
    cairo = Formula["cairo"]
    fontconfig = Formula["fontconfig"]
    freetype = Formula["freetype"]
    gdk_pixbuf = Formula["gdk-pixbuf"]
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    harfbuzz = Formula["harfbuzz"]
    libepoxy = Formula["libepoxy"]
    libpng = Formula["libpng"]
    pango = Formula["pango"]
    pixman = Formula["pixman"]
    flags = %W[
      -I#{atk.opt_include}/atk-1.0
      -I#{cairo.opt_include}/cairo
      -I#{fontconfig.opt_include}
      -I#{freetype.opt_include}/freetype2
      -I#{gdk_pixbuf.opt_include}/gdk-pixbuf-2.0
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/gio-unix-2.0/
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{harfbuzz.opt_include}/harfbuzz
      -I#{include}
      -I#{include}/gtk-3.0
      -I#{libepoxy.opt_include}
      -I#{libpng.opt_include}/libpng16
      -I#{pango.opt_include}/pango-1.0
      -I#{pixman.opt_include}/pixman-1
      -D_REENTRANT
      -L#{atk.opt_lib}
      -L#{cairo.opt_lib}
      -L#{gdk_pixbuf.opt_lib}
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{lib}
      -L#{pango.opt_lib}
      -latk-1.0
      -lcairo
      -lcairo-gobject
      -lgdk-3
      -lgdk_pixbuf-2.0
      -lgio-2.0
      -lglib-2.0
      -lgobject-2.0
      -lgtk-3
      -lpango-1.0
      -lpangocairo-1.0
    ]
    flags << "-lintl" if OS.mac?
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
    # include a version check for the pkg-config files
    assert_match version.to_s, shell_output("cat #{lib}/pkgconfig/gtk+-3.0.pc").strip
  end
end

__END__
diff --git a/gdk/wayland/cursor/meson.build b/gdk/wayland/cursor/meson.build
new file mode 100644
index 0000000000000000000000000000000000000000..02d5f2bed8d926ee26bcf4c4081d18fc9d53fd5b
--- /dev/null
+++ b/gdk/wayland/cursor/meson.build
@@ -0,0 +1,12 @@
+wayland_cursor_sources = files([
+  'wayland-cursor.c',
+  'xcursor.c',
+  'os-compatibility.c'
+])
+
+libwayland_cursor = static_library('wayland+cursor',
+  sources: wayland_cursor_sources,
+  include_directories: [ confinc, ],
+  dependencies: [ glib_dep, wlclientdep, ],
+  c_args: common_cflags,
+)
