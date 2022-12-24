class Gdal < Formula
  desc "Geospatial Data Abstraction Library"
  homepage "https://www.gdal.org/"
  url "http://download.osgeo.org/gdal/3.6.1/gdal-3.6.1.tar.xz"
  sha256 "68f1c03547ff7152289789db7f67ee634167c9b7bfec4872b88406b236f9c230"
  license "MIT"

  livecheck do
    url "https://download.osgeo.org/gdal/CURRENT/"
    regex(/href=.*?gdal[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "0d8d8a1456c387895b74de0b09b62f8bdaa582a764154d94feefd88dcd8cdce3"
    sha256 arm64_monterey: "4fe3a40599cbfb49e4b711520dc14247726887afcecb79e403e3a74d27ae1d44"
    sha256 arm64_big_sur:  "ab34db9823d44c712eb01994d36b25cf5fcb4f2b4cf479ae84d731f56adabc3c"
    sha256 ventura:        "ed6a428b3a1a93dce566a20f9c622922be4a59cc5dcdddb85290cfc4e43b1e07"
    sha256 monterey:       "586d2ad1eea2a61b5c18accb43fa9d8c647ce4db8ca423c7b369bafedc4f688a"
    sha256 big_sur:        "35b2ab24a3780e42ab926493eb45d896de0d8952f4a2c80d348e806488c8f94f"
    sha256 x86_64_linux:   "bdbd5a7c4f5edcede0bb0b0eaf3c408b74eed215cdab367652b67815d5f68c3f"
  end

  head do
    url "https://github.com/OSGeo/gdal.git", branch: "master"
    depends_on "doxygen" => :build
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "apache-arrow"
  depends_on "cfitsio"
  depends_on "epsilon"
  depends_on "expat"
  depends_on "freexl"
  depends_on "geos"
  depends_on "giflib"
  depends_on "hdf5"
  depends_on "jpeg-turbo"
  depends_on "jpeg-xl"
  depends_on "json-c"
  depends_on "libdap"
  depends_on "libgeotiff"
  depends_on "libheif"
  depends_on "libpng"
  depends_on "libpq"
  depends_on "libspatialite"
  depends_on "libtiff"
  depends_on "libxml2"
  depends_on "netcdf"
  depends_on "numpy"
  depends_on "openexr"
  depends_on "openjpeg"
  depends_on "pcre2"
  depends_on "poppler"
  depends_on "proj"
  depends_on "python@3.11"
  depends_on "sqlite"
  depends_on "unixodbc"
  depends_on "webp"
  depends_on "xerces-c"
  depends_on "xz"
  depends_on "zstd"

  uses_from_macos "curl"

  on_linux do
    depends_on "util-linux"
  end

  conflicts_with "avce00", because: "both install a cpl_conv.h header"
  conflicts_with "cpl", because: "both install cpl_error.h"

  fails_with gcc: "5"

  def python3
    "python3.11"
  end

  def install
    # Work around Homebrew's "prefix scheme" patch which causes non-pip installs
    # to incorrectly try to write into HOMEBREW_PREFIX/lib since Python 3.10.
    inreplace "swig/python/CMakeLists.txt",
              /(set\(INSTALL_ARGS "--single-version-externally-managed --record=record.txt")\)/,
              "\\1 --install-lib=#{prefix/Language::Python.site_packages(python3)})"

    system "cmake", "-S", ".", "-B", "build",
                    "-DBUILD_PYTHON_BINDINGS=ON",
                    "-DPython_EXECUTABLE=#{which(python3)}",
                    "-DENABLE_PAM=ON",
                    "-DCMAKE_INSTALL_RPATH=#{lib}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    # basic tests to see if third-party dylibs are loading OK
    system bin/"gdalinfo", "--formats"
    system bin/"ogrinfo", "--formats"
    # Changed Python package name from "gdal" to "osgeo.gdal" in 3.2.0.
    system python3, "-c", "import osgeo.gdal"
  end
end
