class GnomeLatex < Formula
  desc "LaTeX editor for the GNOME desktop"
  homepage "https://gitlab.gnome.org/swilmet/gnome-latex"
  url "https://gitlab.gnome.org/swilmet/gnome-latex.git",
      tag:      "3.44.0",
      revision: "8083f0476247feb29afac2682ee640dd18b8a6cf"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_ventura:  "f06efbf2dbba8b342210c88d0343a9ea7dcc0ea2635be6547e74d2caeb9cfa70"
    sha256 arm64_monterey: "51de73af3ae1d9c55c091d36268e1874d4edc12d73f8bbcf21925fd57c4b7b5a"
    sha256 arm64_big_sur:  "b067b352478df9a74e3650d1397485db30d255e1360c9265381bba9845ba8d5d"
    sha256 ventura:        "19a2472d46a29cc3fd5cd48883cf5ebbf7c8dbfe08c20208bb77564511962c40"
    sha256 monterey:       "3c4c5d295ffee44a5c7acbff6ff0b9e5bc9eef749584861b35d46397d03446a9"
    sha256 big_sur:        "04f05bd4f4c55742f72673520076ce9899df5934f9421deff5344d8177298637"
    sha256 x86_64_linux:   "7e243ca213ca46495cc3798a5b6a5d7fae042da5a25537608c67d1a6ea704704"
  end

  depends_on "appstream-glib" => :build
  depends_on "autoconf" => :build
  depends_on "autoconf-archive" => :build
  depends_on "automake" => :build
  depends_on "gobject-introspection" => :build
  depends_on "gtk-doc" => :build
  depends_on "intltool" => :build
  depends_on "itstool" => :build
  depends_on "pkg-config" => :build
  depends_on "vala" => :build
  depends_on "yelp-tools" => :build
  depends_on "adwaita-icon-theme"
  depends_on "gnome-themes-standard"
  depends_on "gspell"
  depends_on "libgee"
  depends_on "tepl"

  uses_from_macos "perl" => :build

  def install
    # Needed by intltool (xml::parser)
    ENV.prepend_path "PERL5LIB", "#{Formula["intltool"].libexec}/lib/perl5" unless OS.mac?

    system "./autogen.sh", "--disable-schemas-compile",
                           "--disable-dependency-tracking",
                           "--disable-silent-rules",
                           "--disable-code-coverage",
                           "--disable-dconf-migration",
                           "--prefix=#{prefix}"
    system "make", "install"
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas",
           "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
    system "#{Formula["gtk+3"].opt_bin}/gtk3-update-icon-cache", "-f", "-t",
           "#{HOMEBREW_PREFIX}/share/icons/hicolor"
    system "#{Formula["gtk+3"].opt_bin}/gtk3-update-icon-cache", "-f", "-t",
           "#{HOMEBREW_PREFIX}/share/icons/HighContrast"
  end

  test do
    system "#{bin}/gnome-latex", "--version"
  end
end
