class Z3 < Formula
  desc "High-performance theorem prover"
  homepage "https://github.com/Z3Prover/z3"
  url "https://github.com/Z3Prover/z3/archive/z3-4.11.2.tar.gz"
  sha256 "e3a82431b95412408a9c994466fad7252135c8ed3f719c986cd75c8c5f234c7e"
  license "MIT"
  revision 1
  head "https://github.com/Z3Prover/z3.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/z3[._-]v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "cec4d6c863d607ea1622f296d2804942d81234431159e2da7bf446c7bd341365"
    sha256 cellar: :any,                 arm64_monterey: "7825fd2139a43998402e33b780eda21f88bbd715f7aed70585abd73e07a81fee"
    sha256 cellar: :any,                 arm64_big_sur:  "6922b4af3ceaf632eccbae7ee3e1779ee259085c65dfce33c2d32e2fab6d2ad4"
    sha256 cellar: :any,                 ventura:        "65b6a12c7d25bb6165831f74e3ae6cb9de3bff5f5b864729433bdd7fd2eda845"
    sha256 cellar: :any,                 monterey:       "7f9aad29cdbafc7b78ae98dcbf4421a1074651a9e85332d5237dee671a4eac98"
    sha256 cellar: :any,                 big_sur:        "33f9c591649639c3b216702a98787a3c416eb25aaaa2d1316b81f6649f5ed4af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f87c3a49f986b2ada34629c8f899daf5103ebfa9c1e49a45df9eada19b4062d0"
  end

  depends_on "cmake" => :build
  # Has Python bindings but are supplementary to the main library
  # which does not need Python.
  depends_on "python@3.11" => [:build, :test]

  fails_with gcc: "5"

  def python3
    which("python3.11")
  end

  def install
    # LTO on Intel Monterey produces segfaults.
    # https://github.com/Z3Prover/z3/issues/6414
    do_lto = MacOS.version < :monterey || Hardware::CPU.arm?
    args = %W[
      -DZ3_LINK_TIME_OPTIMIZATION=#{do_lto ? "ON" : "OFF"}
      -DZ3_INCLUDE_GIT_DESCRIBE=OFF
      -DZ3_INCLUDE_GIT_HASH=OFF
      -DZ3_INSTALL_PYTHON_BINDINGS=ON
      -DZ3_BUILD_EXECUTABLE=ON
      -DZ3_BUILD_TEST_EXECUTABLES=OFF
      -DZ3_BUILD_PYTHON_BINDINGS=ON
      -DZ3_BUILD_DOTNET_BINDINGS=OFF
      -DZ3_BUILD_JAVA_BINDINGS=OFF
      -DZ3_USE_LIB_GMP=OFF
      -DPYTHON_EXECUTABLE=#{python3}
      -DCMAKE_INSTALL_PYTHON_PKG_DIR=#{Language::Python.site_packages(python3)}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    system "make", "-C", "contrib/qprofdiff"
    bin.install "contrib/qprofdiff/qprofdiff"

    pkgshare.install "examples"
  end

  test do
    system ENV.cc, pkgshare/"examples/c/test_capi.c", "-I#{include}",
                   "-L#{lib}", "-lz3", "-o", testpath/"test"
    system "./test"
    assert_equal version.to_s, shell_output("#{python3} -c 'import z3; print(z3.get_version_string())'").strip
  end
end
