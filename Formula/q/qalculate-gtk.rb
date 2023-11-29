class QalculateGtk < Formula
  desc "Multi-purpose desktop calculator"
  homepage "https://qalculate.github.io/"
  url "https://mirror.ghproxy.com/https://github.com/Qalculate/qalculate-gtk/releases/download/v4.8.1/qalculate-gtk-4.8.1.tar.gz"
  sha256 "b97e84a5f52b277eefb8e5b9b60cfc7aeed3b243f92a9725ff9cc3aeeacf41c2"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    sha256 arm64_sonoma:   "d9130437dbd844e75a386425ae1aed546675f9061b37611d0e276d855694a54e"
    sha256 arm64_ventura:  "47c159e005b330fbddf22498777e8a58f5b524cbbb56efe5e14380aca568c427"
    sha256 arm64_monterey: "a27d0d0c91a2a9e672759b6322953d5277ebc88e204cc88a0fb87b4ae023661c"
    sha256 sonoma:         "371a65dba0ffcaa97d2ca939c7e5b33a00eeafd5593cf5256765b82a140cb434"
    sha256 ventura:        "8aefe91404f2ad02f1c3c729b19c1095a0f0af2e481e33cd7e0b328244d4d1b9"
    sha256 monterey:       "c8952161fd8589901a3175599d7da2389752d2c739fd10ca65db7615bc920402"
    sha256 x86_64_linux:   "89d9430ff7e2c8415420b0535a4b616dd1fe5206f591061ab3169ff1827c3a74"
  end

  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "adwaita-icon-theme"
  depends_on "gtk+3"
  depends_on "libqalculate"

  uses_from_macos "perl" => :build

  on_linux do
    depends_on "perl-xml-parser" => :build
  end

  def install
    ENV.prepend_path "PERL5LIB", Formula["perl-xml-parser"].libexec/"lib/perl5" unless OS.mac?

    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/qalculate-gtk", "-v"
  end
end
