class Texinfo < Formula
  desc "Official documentation format of the GNU project"
  homepage "https://www.gnu.org/software/texinfo/"
  url "https://ftp.gnu.org/gnu/texinfo/texinfo-7.0.1.tar.xz"
  mirror "https://ftpmirror.gnu.org/texinfo/texinfo-7.0.1.tar.xz"
  sha256 "bcd221fdb2d807a8a09938a0f8d5e010ebd2b58fca16075483d6fcb78db2c6b2"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_ventura:  "2ad2c341570b96e5d1d139abe0c7070c03b731645da4c1a3aa14b02516372c6e"
    sha256 arm64_monterey: "594597765c2aa357c136322606b1bd5bf04465cc0330c698269e8ad3cb9d5875"
    sha256 arm64_big_sur:  "57f426550721aacfe39fb53fc7d88c341c8670d2e738028495cea98d1a716277"
    sha256 ventura:        "d34cea65a60480591758dded9219f6a145c5778aac009bb84f62b1289a2ef380"
    sha256 monterey:       "66f27d06a7b00f627d677d35b1309ef3c2c4dd2eb2420904e451d56027eadeac"
    sha256 big_sur:        "2fa5239618395f422b1554a15f1ed45933bbc621dc4439792aa46315a38f842f"
    sha256 x86_64_linux:   "01afbaca71a6acb6dd68bec6e97ff75c3d66833036a8d64523810def13bb34fd"
  end

  uses_from_macos "ncurses"
  uses_from_macos "perl"

  # texinfo has been removed from macOS Ventura.
  on_monterey :or_older do
    keg_only :provided_by_macos
  end

  on_system :linux, macos: :high_sierra_or_older do
    depends_on "gettext"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-install-warnings",
                          "--prefix=#{prefix}"
    system "make", "install"
    doc.install Dir["doc/refcard/txirefcard*"]
  end

  test do
    (testpath/"test.texinfo").write <<~EOS
      @ifnottex
      @node Top
      @top Hello World!
      @end ifnottex
      @bye
    EOS
    system "#{bin}/makeinfo", "test.texinfo"
    assert_match "Hello World!", File.read("test.info")
  end
end
