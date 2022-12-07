class Graphicsmagick < Formula
  desc "Image processing tools collection"
  homepage "http://www.graphicsmagick.org/"
  url "https://downloads.sourceforge.net/project/graphicsmagick/graphicsmagick/1.3.38/GraphicsMagick-1.3.38.tar.xz"
  sha256 "d60cd9db59351d2b9cb19beb443170acaa28f073d13d258f67b3627635e32675"
  license "MIT"
  revision 2
  head "http://hg.code.sf.net/p/graphicsmagick/code", using: :hg

  livecheck do
    url "https://sourceforge.net/projects/graphicsmagick/rss?path=/graphicsmagick"
  end

  bottle do
    sha256 arm64_ventura:  "9d0c19082798136f56653befe206c15bcb25e18b9776d61a423beb2ba54ccc1c"
    sha256 arm64_monterey: "27e822354194c54efdd88a66863a68e408db7a66d1e8b90540232656eb49f4bf"
    sha256 arm64_big_sur:  "81a66f25de0b9b9012deb9064ff2f51ff3b7b19203f4b41afcd4ac6e4a7c0fa8"
    sha256 ventura:        "5114e31150c4c518079ed0c16f5b08c9f24fd43a78c14a008627f3bd86d80676"
    sha256 monterey:       "16621a3839579df37d8966e37faaaf4e7626c4108c60b68591d6ba4c9871ea4e"
    sha256 big_sur:        "2a8d4f330b472b229b49524d02d84db9cc2aee07ef48f278d8b8358b62cd812a"
    sha256 x86_64_linux:   "ac9e82a002e9af78da4ca6100567102829b192414a0fc499dc453b02b76d0098"
  end

  depends_on "pkg-config" => :build
  depends_on "freetype"
  depends_on "jasper"
  depends_on "jpeg-turbo"
  depends_on "jpeg-xl"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "libtool"
  depends_on "little-cms2"
  depends_on "webp"

  uses_from_macos "bzip2"
  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  skip_clean :la

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --disable-openmp
      --disable-static
      --enable-shared
      --with-modules
      --with-quantum-depth=16
      --without-lzma
      --without-x
      --without-gslib
      --with-gs-font-dir=#{HOMEBREW_PREFIX}/share/ghostscript/fonts
      --without-wmf
      --with-jxl
    ]

    # versioned stuff in main tree is pointless for us
    inreplace "configure", "${PACKAGE_NAME}-${PACKAGE_VERSION}", "${PACKAGE_NAME}"
    system "./configure", *args
    system "make", "install"
  end

  test do
    fixture = test_fixtures("test.png")
    assert_match "PNG 8x8+0+0", shell_output("#{bin}/gm identify #{fixture}")
  end
end
