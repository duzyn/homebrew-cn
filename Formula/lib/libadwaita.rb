class Libadwaita < Formula
  desc "Building blocks for modern adaptive GNOME applications"
  homepage "https://gnome.pages.gitlab.gnome.org/libadwaita/"
  url "https://download.gnome.org/sources/libadwaita/1.4/libadwaita-1.4.3.tar.xz"
  sha256 "ae9622222b0eb18e23675655ad2ba01741db4d8655a796f4cf077b093e2f5841"
  license "LGPL-2.1-or-later"

  # libadwaita doesn't use GNOME's "even-numbered minor is stable" version
  # scheme. This regex is the same as the one generated by the `Gnome` strategy
  # but it's necessary to avoid the related version scheme logic.
  livecheck do
    url :stable
    regex(/libadwaita-(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "04e1553250f032164120c800ec635454aea38ffd65620740d803fecb826423a5"
    sha256 arm64_ventura:  "aa4707426b2c9cad67324cd2537b9c338a69572f5b21ca7ed46cb77f39817f2c"
    sha256 arm64_monterey: "812dc1cdd1e633d8828a3baba10ec1772b0158cd4a558947360f805823675160"
    sha256 sonoma:         "11ca3893167d0a7150706d56bac3c484cc75505c027a469e22b8bff563f07e31"
    sha256 ventura:        "bce5805be6360784e19be4a774352fe5bb1072d9483e97884bdeb5e052251d00"
    sha256 monterey:       "f859d02cd9413a2acf7dc86cc0617203d0cbb29bc144315e378bc0b305b209f3"
    sha256 x86_64_linux:   "ff99a839299a1b4aa3837b1e9898deed4cd68e86d819fac2c3c515da2e8d46c7"
  end

  depends_on "cmake" => :build
  depends_on "gettext" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "vala" => :build
  depends_on "appstream"
  depends_on "gtk4"

  uses_from_macos "python" => :build

  def install
    system "meson", "setup", "build", "-Dtests=false", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <adwaita.h>

      int main(int argc, char *argv[]) {
        g_autoptr (AdwApplication) app = NULL;
        app = adw_application_new ("org.example.Hello", G_APPLICATION_DEFAULT_FLAGS);
        return g_application_run (G_APPLICATION (app), argc, argv);
      }
    EOS
    flags = shell_output("#{Formula["pkg-config"].opt_bin}/pkg-config --cflags --libs libadwaita-1").strip.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test", "--help"

    # include a version check for the pkg-config files
    assert_match version.to_s, (lib/"pkgconfig/libadwaita-1.pc").read
  end
end
