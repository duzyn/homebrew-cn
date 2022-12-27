class Singular < Formula
  desc "Computer algebra system for polynomial computations"
  homepage "https://www.singular.uni-kl.de/"
  url "https://www.singular.uni-kl.de/ftp/pub/Math/Singular/SOURCES/4-3-1/singular-4.3.1p2.tar.gz"
  version "4.3.1p2"
  sha256 "95814bba0f0bd0290cd9799ec1d2ecc6f4c8a4e6429d9a02eb7f9c4e5649682a"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.singular.uni-kl.de/ftp/pub/Math/Singular/SOURCES/"
    regex(%r{href=["']?v?(\d+(?:[.-]\d+)+)/?["' >]}i)
    strategy :page_match do |page, regex|
      # Match versions from directories
      versions = page.scan(regex)
                     .flatten
                     .uniq
                     .map { |v| Version.new(v.tr("-", ".")) }
                     .reject { |v| v.patch >= 90 }
                     .sort
      next versions if versions.blank?

      # Assume the last-sorted version is newest
      newest_version = versions.last

      # Fetch the page for the newest version directory
      dir_page = Homebrew::Livecheck::Strategy.page_content(
        URI.join(@url, "#{newest_version.to_s.tr(".", "-")}/"),
      )
      next versions if dir_page[:content].blank?

      # Identify versions from files in the version directory
      dir_versions = dir_page[:content].scan(/href=.*?singular[._-]v?(\d+(?:\.\d+)+(?:p\d+)?)\.t/i).flatten

      dir_versions || versions
    end
  end

  bottle do
    rebuild 1
    sha256 arm64_ventura:  "9d4fb3984426e03ae30ed2b10aa4b8b9181b8620af7fb851dd6446ec09fe63fc"
    sha256 arm64_monterey: "5afe787f5cff30830f08cd111ff0d433837bb24feffbc81727422561e7273b6c"
    sha256 arm64_big_sur:  "6547d08c1cfd9271136712a6640fd20603f726bcfd89d7888648f45b3b69452b"
    sha256 ventura:        "27d5cdb9568ba78d792588a272b3f034cec9b9fa2810048a490c129db5d899f3"
    sha256 monterey:       "31669bf0c54df501eaafa744b56f58e9585ccc9d9fded98172e427190b97ebb6"
    sha256 big_sur:        "73908a3994f2063c76c0066434927620e86b3531c219048c70b8bc49e590b41b"
    sha256 x86_64_linux:   "4d05af32c243cdc7f3a61e133d629efd599c4bb840896b268f9de6e845e14fe1"
  end

  head do
    url "https://github.com/Singular/Singular.git", branch: "spielwiese"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "gmp"
  depends_on "mpfr"
  depends_on "ntl"
  depends_on "python@3.11"

  on_macos do
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def install
    # Run autogen on macOS so that -flat_namespace flag is not used.
    system "./autogen.sh" if build.head? || OS.mac?
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-python=#{which("python3.11")}",
                          "CXXFLAGS=-std=c++11"
    system "make", "install"
  end

  test do
    testinput = <<~EOS
      ring r = 0,(x,y,z),dp;
      poly p = x;
      poly q = y;
      poly qq = z;
      p*q*qq;
    EOS
    assert_match "xyz", pipe_output("#{bin}/Singular", testinput, 0)
  end
end
