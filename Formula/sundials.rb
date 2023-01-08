class Sundials < Formula
  desc "Nonlinear and differential/algebraic equations solver"
  homepage "https://computing.llnl.gov/projects/sundials"
  url "https://ghproxy.com/github.com/LLNL/sundials/releases/download/v6.5.0/sundials-6.5.0.tar.gz"
  sha256 "4e0b998dff292a2617e179609b539b511eb80836f5faacf800e688a886288502"
  license "BSD-3-Clause"

  livecheck do
    url "https://computing.llnl.gov/projects/sundials/sundials-software"
    regex(/href=.*?sundials[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "3a4acc4f7c00b60ea532287baf4c1e472677fc133fded0b8f141abb28d8cce21"
    sha256 cellar: :any,                 arm64_monterey: "bddd45f9878edc4e15e81e47338f8651509a7b21fe96c6c524486bea725060e3"
    sha256 cellar: :any,                 arm64_big_sur:  "f5c24b74aa603bf847d92410b1dc09635fac2d129f54809315fa83e7b4e5b36a"
    sha256 cellar: :any,                 ventura:        "a2ec79fc5c534824d06c78ceb27f82d40167875714de95dad8b3bffd2c191f55"
    sha256 cellar: :any,                 monterey:       "5a467f62fac80e5c7500081b90783fdec403f116ec00e5b519fef912dea76ddd"
    sha256 cellar: :any,                 big_sur:        "1abd29bb4275e316e8f31e5269b2e525442eba0e13447170be55ebf9d0261a91"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "07ba35bfcf4afa2139794d08034c151fd6ce689b13519a9be3917383dcac6c40"
  end

  depends_on "cmake" => :build
  depends_on "gcc" # for gfortran
  depends_on "open-mpi"
  depends_on "openblas"
  depends_on "suite-sparse"

  uses_from_macos "libpcap"

  def install
    blas = "-L#{Formula["openblas"].opt_lib} -lopenblas"
    args = %W[
      -DBUILD_SHARED_LIBS=ON
      -DKLU_ENABLE=ON
      -DKLU_LIBRARY_DIR=#{Formula["suite-sparse"].opt_lib}
      -DKLU_INCLUDE_DIR=#{Formula["suite-sparse"].opt_include}
      -DLAPACK_ENABLE=ON
      -DLAPACK_LIBRARIES=#{blas};#{blas}
      -DMPI_ENABLE=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Only keep one example for testing purposes
    (pkgshare/"examples").install Dir[prefix/"examples/nvector/serial/*"] \
                                  - Dir[prefix/"examples/nvector/serial/{CMake*,Makefile}"]
    (prefix/"examples").rmtree
  end

  test do
    cp Dir[pkgshare/"examples/*"], testpath
    system ENV.cc, "test_nvector.c", "test_nvector_serial.c", "-o", "test",
                   "-I#{include}", "-L#{lib}", "-lsundials_nvecserial", "-lm"
    assert_match "SUCCESS: NVector module passed all tests",
                 shell_output("./test 42 0")
  end
end
