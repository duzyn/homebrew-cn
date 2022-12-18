class ImagemagickAT6 < Formula
  desc "Tools and libraries to manipulate images in many formats"
  homepage "https://legacy.imagemagick.org/"
  url "https://imagemagick.org/archive/releases/ImageMagick-6.9.12-70.tar.xz"
  sha256 "d53afcabc763a2198d81ff20274adec39b5168733558c91081fc0ef7aa470ce7"
  license "ImageMagick"
  head "https://github.com/imagemagick/imagemagick6.git", branch: "main"

  livecheck do
    url "https://imagemagick.org/archive/"
    regex(/href=.*?ImageMagick[._-]v?(6(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "b254938dbc76e383785fc655e51be2b34b4cc2146f3d9551b9419f57d74368c2"
    sha256 arm64_monterey: "7814974326bb4b2f66d89e839f27294845b2743d2e45ebff4452d47f24e8885e"
    sha256 arm64_big_sur:  "2e325f68829e45a192303639f09fc833dde895c9dc4c762be2e09cebce1d96c7"
    sha256 ventura:        "02fc1598c4833d55f6ad0faf1e0b8d549c8b74b7e90bdf9fc786570cfaad90ac"
    sha256 monterey:       "a0bab40fc098ee30576274a399124b9e2d85a12d1c17907d5109ce219a3c6c10"
    sha256 big_sur:        "93ff6068e84ab627b4c8a22d5c79d74a17d7acd396f4f72c493bc77400972c67"
    sha256 x86_64_linux:   "53a277868e14695c1d73e2bf139ae443f3430fe505bc6de87cfaa437e60596ea"
  end

  keg_only :versioned_formula

  depends_on "pkg-config" => :build

  depends_on "freetype"
  depends_on "ghostscript"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "libtool"
  depends_on "little-cms2"
  depends_on "openjpeg"
  depends_on "webp"
  depends_on "xz"

  uses_from_macos "libxml2"

  skip_clean :la

  def install
    # Avoid references to shim
    inreplace Dir["**/*-config.in"], "@PKG_CONFIG@", Formula["pkg-config"].opt_bin/"pkg-config"

    args = %W[
      --enable-osx-universal-binary=no
      --prefix=#{prefix}
      --disable-dependency-tracking
      --disable-silent-rules
      --disable-opencl
      --disable-openmp
      --enable-shared
      --enable-static
      --with-freetype=yes
      --with-modules
      --with-webp=yes
      --with-openjp2
      --with-gslib
      --with-gs-font-dir=#{HOMEBREW_PREFIX}/share/ghostscript/fonts
      --without-fftw
      --without-pango
      --without-x
      --without-wmf
    ]

    # versioned stuff in main tree is pointless for us
    inreplace "configure", "${PACKAGE_NAME}-${PACKAGE_BASE_VERSION}", "${PACKAGE_NAME}"
    system "./configure", *args
    system "make", "install"
  end

  test do
    assert_match "PNG", shell_output("#{bin}/identify #{test_fixtures("test.png")}")
    # Check support for recommended features and delegates.
    features = shell_output("#{bin}/convert -version")
    %w[Modules freetype jpeg png tiff].each do |feature|
      assert_match feature, features
    end
  end
end
