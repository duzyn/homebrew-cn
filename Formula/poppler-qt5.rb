class PopplerQt5 < Formula
  desc "PDF rendering library (based on the xpdf-3.0 code base)"
  homepage "https://poppler.freedesktop.org/"
  url "https://poppler.freedesktop.org/poppler-22.12.0.tar.xz"
  sha256 "d9aa9cacdfbd0f8e98fc2b3bb008e645597ed480685757c3e7bc74b4278d15c0"
  license "GPL-2.0-only"
  head "https://gitlab.freedesktop.org/poppler/poppler.git", branch: "master"

  livecheck do
    formula "poppler"
  end

  bottle do
    sha256                               arm64_ventura:  "443b94fd706ac27a020cae94ba86cd74e6738cb24813196fd0e6db48136daa10"
    sha256                               arm64_monterey: "3245f9e3837f7b8b45cb3dde9155117d614595c26554910f72d49b26a58963b5"
    sha256                               arm64_big_sur:  "69c5d7bf6dbd339c7f95520d2485b2d7afe6545f405e6b8350e184990a1655e0"
    sha256                               ventura:        "e0394000e1d0572baf3a36862bc6847b27f920fc0e074abe9819b9a97aa0cf9d"
    sha256                               monterey:       "21d400f9e5c77ce814a82ec1b452020bc39b39e6c0126b813a3d1b8c115cb7ec"
    sha256                               big_sur:        "662fcde7884fe4b658ee203e643c9785d5bdd06cec486cb82bb99c468cb3cbc7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c614c5bb92220a3e14063e37cacf92fd66398272d23372046dd41a82962a0728"
  end

  keg_only "it conflicts with poppler"

  depends_on "cmake" => :build
  depends_on "gobject-introspection" => :build
  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "gettext"
  depends_on "glib"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "little-cms2"
  depends_on "nss"
  depends_on "openjpeg"
  depends_on "qt@5"

  uses_from_macos "gperf" => :build
  uses_from_macos "curl"

  fails_with gcc: "5"

  resource "font-data" do
    url "https://poppler.freedesktop.org/poppler-data-0.4.11.tar.gz"
    sha256 "2cec05cd1bb03af98a8b06a1e22f6e6e1a65b1e2f3816cb3069bb0874825f08c"
  end

  def install
    ENV.cxx11

    args = std_cmake_args + %W[
      -DBUILD_GTK_TESTS=OFF
      -DENABLE_BOOST=OFF
      -DENABLE_CMS=lcms2
      -DENABLE_GLIB=ON
      -DENABLE_QT5=ON
      -DENABLE_QT6=OFF
      -DENABLE_UNSTABLE_API_ABI_HEADERS=ON
      -DWITH_GObjectIntrospection=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]

    system "cmake", ".", *args
    system "make", "install"
    system "make", "clean"
    system "cmake", ".", "-DBUILD_SHARED_LIBS=OFF", *args
    system "make"
    lib.install "libpoppler.a"
    lib.install "cpp/libpoppler-cpp.a"
    lib.install "glib/libpoppler-glib.a"
    resource("font-data").stage do
      system "make", "install", "prefix=#{prefix}"
    end
  end

  test do
    system "#{bin}/pdfinfo", test_fixtures("test.pdf")
  end
end
