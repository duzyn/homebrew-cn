class Highs < Formula
  desc "Linear optimization software"
  homepage "https://www.maths.ed.ac.uk/hall/HiGHS/"
  url "https://github.com/ERGO-Code/HiGHS/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "ed1819e6a36ae9c9c4c17959fef0cea54decca25985ff5c268dd4dd4f6dc3494"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "41e9fddf76618d81080b629fed0160f54e9f4f5ec71c878a8bb78747e3d372e6"
    sha256 cellar: :any,                 arm64_monterey: "d6927104c62d2353f0b9e5a0ca644cd1a4d45332fc005aa03f93940aebedf934"
    sha256 cellar: :any,                 arm64_big_sur:  "24ee0872c9dac09b73935e227e3b309e3bebae52efcf564e86f3123e7324d9e1"
    sha256 cellar: :any,                 monterey:       "3a791eb4e3ffd9e03e6b519f722ae89db070f495e3ec236c405742aae908bec6"
    sha256 cellar: :any,                 big_sur:        "b8ab93adcd67ad3049803efa9fa96745e408bf167a51a6bd19d9a5c02f956dc0"
    sha256 cellar: :any,                 catalina:       "74a68f488b0ecac4609bf9c3d6725c46285a251217ff3e1be5f0b448dc25b63f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7d0f8804907f17bc5b06bd581784022b09b967c4581be3e01965231376122997"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "gcc" # for gfortran
  depends_on "osi"

  uses_from_macos "zlib"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "check", "examples"
  end

  test do
    output = shell_output("#{bin}/highs #{pkgshare}/check/instances/test.mps")
    assert_match "Optimal", output

    cp pkgshare/"examples/call_highs_from_cpp.cpp", testpath/"test.cpp"
    system ENV.cxx, "-std=c++11", "test.cpp", "-I#{include}/highs", "-L#{lib}", "-lhighs", "-o", "test"
    assert_match "Optimal", shell_output("./test")
  end
end
