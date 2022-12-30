class ImagemagickAT6 < Formula
  desc "Tools and libraries to manipulate images in many formats"
  homepage "https://legacy.imagemagick.org/"
  url "https://imagemagick.org/archive/releases/ImageMagick-6.9.12-71.tar.xz"
  sha256 "fa3eea5a3e5c4819efc008811901ed3d6288cbcd088001339b8c786d3148c15a"
  license "ImageMagick"
  head "https://github.com/imagemagick/imagemagick6.git", branch: "main"

  livecheck do
    url "https://imagemagick.org/archive/"
    regex(/href=.*?ImageMagick[._-]v?(6(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "a46c6f51751d84223d4300b750b3c5f48fa7232dfd41440c8e80fa1a4ee4d9b6"
    sha256 arm64_monterey: "a46c20d202d80cf097b043bbeb2578f3a2a85d81f70cf64e0c49526001701660"
    sha256 arm64_big_sur:  "fd4e7c0c450337b8c4a732b86231807105e3f6d9f5dac8573ae3733ce3d7b6e1"
    sha256 ventura:        "9cc22258f988b41f944b291a45d58df44931965683c240372eba6e7aeaf1000e"
    sha256 monterey:       "1456f1b36713a1315633dee1639bb5250cb6c6740911f0cceddeff063d73f6ba"
    sha256 big_sur:        "6cf14a6795d4f38b30a29fe4f4aca0ebdde8498aa53110ecf9d330f9e0f5fbe1"
    sha256 x86_64_linux:   "30af7c5afb0e8ca5a1fed5ff45a1638c928d8fe14199c2d4327c27fa76d60fff"
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
