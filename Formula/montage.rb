class Montage < Formula
  desc "Toolkit for assembling FITS images into custom mosaics"
  homepage "http://montage.ipac.caltech.edu"
  url "http://montage.ipac.caltech.edu/download/Montage_v6.0.tar.gz"
  sha256 "1f540a7389d30fcf9f8cd9897617cc68b19350fbcde97c4d1cdc5634de1992c6"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/Caltech-IPAC/Montage.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "5fb0ba7f92da2f1640b5b167a534e25dbbd8bfca5985496dc3160b8c80f8e941"
    sha256 cellar: :any, arm64_monterey: "3351038e38cb15aea0c03e8085869f13d7a08e595b3ac175d7e516ebbb23930b"
    sha256 cellar: :any, arm64_big_sur:  "89c301642c9ecdbc1735d7c4f7a2d4682579df7c47bbc79b4a9ca458f8ac612a"
    sha256 cellar: :any, ventura:        "dd2019c0ad78b267ca235ad2d7a49a1554e94bba0e5366846ce79f6cf5d923c0"
    sha256 cellar: :any, monterey:       "31f5c80d33f8b8ab6c19931c2d9ee4ce8afbc5bf3521beb30852caf253144acb"
    sha256 cellar: :any, big_sur:        "185ebdfbbeacdfb4e2c5bf3b3e96e8a9bb21d74415612bab5417024465849ee9"
  end

  depends_on "cfitsio"
  depends_on "freetype"
  depends_on "jpeg-turbo"

  uses_from_macos "bzip2"

  conflicts_with "wdiff", because: "both install an `mdiff` executable"

  def install
    # Avoid building bundled libraries
    libs = %w[bzip2 cfitsio freetype jpeg]
    buildpath.glob("lib/src/{#{libs.join(",")}}*").map(&:rmtree)
    inreplace "lib/src/Makefile", /^[ \t]*\(cd (?:#{libs.join("|")}).*\)$/, ""
    inreplace "MontageLib/Makefile", %r{^.*/lib/src/(?:#{libs.join("|")}).*$\n}, ""
    inreplace "MontageLib/Viewer/Makefile.#{OS.kernel_name.upcase}",
              "-I../../lib/freetype/include/freetype2",
              "-I#{Formula["freetype"].opt_include}/freetype2"

    ENV.deparallelize # Build requires targets to be built in specific order
    system "make"
    bin.install Dir["bin/m*"]
  end

  def caveats
    <<~EOS
      Montage is under the Caltech/JPL non-exclusive, non-commercial software
      licence agreement available at:
        http://montage.ipac.caltech.edu/docs/download.html
    EOS
  end

  test do
    system bin/"mHdr", "m31", "1", "template.hdr"
  end
end
