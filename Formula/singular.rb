class Singular < Formula
  desc "Computer algebra system for polynomial computations"
  homepage "https://www.singular.uni-kl.de/"
  url "https://www.singular.uni-kl.de/ftp/pub/Math/Singular/SOURCES/4-3-1/singular-4.3.1p3.tar.gz"
  version "4.3.1p3"
  sha256 "66cfaeee7ab909272fd81050a09cae3ec115652a01adde014a5128a54b97397a"
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
    sha256 arm64_ventura:  "e40719ff3e0135322fc811fc76d4605269780ee4e78467755ef441476cefa452"
    sha256 arm64_monterey: "953b7fc80df9d1a0ddb5e34855f22fe3ff3228d1b5a2b95a03ae2618a8d1462b"
    sha256 arm64_big_sur:  "e5b7760108c5ddcf02f5ea28a87e05d1d6c51484fbf6d6ee6462af53e67d9e2e"
    sha256 ventura:        "b7469162b220ae1d9b4139fbd7397cbe9acfd06b83bebf58ac1f7343517bc17e"
    sha256 monterey:       "9ea25009d125b26911b50c7245c2e13f6765f3684f76e7d43d814064e004c021"
    sha256 big_sur:        "12981be178241af439d9c68f8e4d65ea3774033438c50b03663181aeb603c12b"
    sha256 x86_64_linux:   "320a2fc253e88e5f2eec20b3aae9ee1745587e4744f9c548d331392f306a9022"
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
