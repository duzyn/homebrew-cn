class Qcachegrind < Formula
  desc "Visualize data generated by Cachegrind and Calltree"
  homepage "https://apps.kde.org/kcachegrind/"
  url "https://mirrors.ustc.edu.cn/kde/stable/release-service/24.05.2/src/kcachegrind-24.05.2.tar.xz"
  sha256 "29b01c69da246cb884ae0ce246b58dec1a026acb503190091f2b08f7a24611c8"
  license "GPL-2.0-or-later"
  head "https://invent.kde.org/sdk/kcachegrind.git", branch: "master"

  # We don't match versions like 19.07.80 or 19.07.90 where the patch number
  # is 80+ (beta) or 90+ (RC), as these aren't stable releases.
  livecheck do
    url "https://mirrors.ustc.edu.cn/kde/stable/release-service/"
    regex(%r{href=.*?v?(\d+\.\d+\.(?:(?![89]\d)\d+)(?:\.\d+)*)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b47d95cc4ae9ae4c4b31ae568c9162700e7b5e8d355babb30c8c05ec8b27bcae"
    sha256 cellar: :any,                 arm64_ventura:  "dc806f1a2657ec8f10d2d24e33aa77ee880361b1924083dae08bbaff10b00943"
    sha256 cellar: :any,                 arm64_monterey: "6655e6ccb005df8c2766b98711fb536dda2f8f765e0dd7ef214d06565dcaaaef"
    sha256 cellar: :any,                 sonoma:         "5cc07c981f137e770f3c57f022283951e11f76f9b45d61b471c846d233cccec7"
    sha256 cellar: :any,                 ventura:        "76f5d60f4dacb7d4cd4913e8389b955ae43be160f3ccdbee246ccd7d651a7212"
    sha256 cellar: :any,                 monterey:       "6613cc3e98c19f7bd4dca602ab33be7e01ca4422e554f5ff9037ade967541953"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4401671190ce9cb83081a4545b91e6826fca2748dd02f6af93b4689d0d8fcfe9"
  end

  depends_on "graphviz"
  depends_on "qt"

  fails_with gcc: "5"

  def install
    args = %w[-config release]
    if OS.mac?
      spec = (ENV.compiler == :clang) ? "macx-clang" : "macx-g++"
      args += %W[-spec #{spec}]
    end

    qt = Formula["qt"]
    system qt.opt_bin/"qmake", *args
    system "make"

    if OS.mac?
      prefix.install "qcachegrind/qcachegrind.app"
      bin.install_symlink prefix/"qcachegrind.app/Contents/MacOS/qcachegrind"
    else
      bin.install "qcachegrind/qcachegrind"
    end
  end
end
