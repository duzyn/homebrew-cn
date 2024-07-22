class Libshumate < Formula
  desc "Shumate is a GTK toolkit providing widgets for embedded maps"
  homepage "https://gitlab.gnome.org/GNOME/libshumate"
  url "https://download.gnome.org/sources/libshumate/1.2/libshumate-1.2.2.tar.xz"
  sha256 "6f587579f7f2d60b38d3f4727eb1a8d2feac9cbdc018e53ff5f772a8608fa44b"
  license "LGPL-2.1-or-later"

  # libshumate doesn't use GNOME's "even-numbered minor is stable" version
  # scheme. This regex is the same as the one generated by the `Gnome` strategy
  # but it's necessary to avoid the related version scheme logic.
  livecheck do
    url :stable
    regex(/libshumate[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "a8ab03830e72acfa65d57f0af09af874da1b4197451c9729622129eac1ff0271"
    sha256 cellar: :any, arm64_ventura:  "6cd1fb996ed1e81b4467de78315c94dbce6cabbd068a0c62581cee867425cff7"
    sha256 cellar: :any, arm64_monterey: "d98665a8905fcced0a20b241f92285616e9458676dfeb60121c0cc69f6c140ba"
    sha256 cellar: :any, sonoma:         "4cc68eb783f15ae39364184caf8e99c177c2e8c7495e6b5bc2830a7dad51cee0"
    sha256 cellar: :any, ventura:        "7fc14b4e76b5aa6802d600f1f9cb66629c7c0148edecd98600a1bf9e86b22a2a"
    sha256 cellar: :any, monterey:       "b1807c9603e049c628e188ee8ba3e580411b1c39608c446116a6019947d9677e"
    sha256               x86_64_linux:   "fa70a63ede680fb77a94a2823c25328b3fdf339be2fba101d7d04a027102fb01"
  end

  depends_on "gettext" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "vala" => :build

  depends_on "cairo"
  depends_on "cmake"
  depends_on "gdk-pixbuf"
  depends_on "gi-docgen"
  depends_on "glib"
  depends_on "graphene"
  depends_on "gtk4"
  depends_on "json-glib"
  depends_on "libsoup"
  depends_on "pango"
  depends_on "protobuf-c"
  depends_on "sqlite"

  uses_from_macos "gperf"
  uses_from_macos "icu4c"

  on_macos do
    depends_on "gettext"
  end

  def install
    system "meson", "setup", "build", "-Dgtk_doc=false", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <shumate/shumate.h>

      int main(int argc, char *argv[]) {
        char version[32];
        snprintf(version, 32, "%d.%d.%d", SHUMATE_MAJOR_VERSION, SHUMATE_MINOR_VERSION, SHUMATE_MICRO_VERSION);
        return 0;
      }
    EOS
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["icu4c"].opt_lib/"pkgconfig" if OS.mac?
    flags = shell_output("#{Formula["pkg-config"].opt_bin}/pkg-config --cflags --libs shumate-1.0").strip.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"

    # include a version check for the pkg-config files
    assert_match version.to_s, (lib/"pkgconfig/shumate-1.0.pc").read
  end
end
