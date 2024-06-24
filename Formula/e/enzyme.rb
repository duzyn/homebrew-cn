class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://mirror.ghproxy.com/https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.125.tar.gz"
  sha256 "4b32b3a37e2aa681075e73c1e8cffd2a211907cf635a22e7486b8e0da7d9e5d9"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "39f0ef59f097c96870d71058f736f8b1f27431366fdc153ab88000c187c16412"
    sha256 cellar: :any,                 arm64_ventura:  "933e3e197c1ecba3e2a659061bb5e3530059fa89b578f6e310f8ef1313563217"
    sha256 cellar: :any,                 arm64_monterey: "deaaf1a5b4453439454c39fd24a38fc2b9c6ae227403ed446f584a67626fbce9"
    sha256 cellar: :any,                 sonoma:         "e0b6b45ce1c321c2da6e89389a7fb8d220442ce41c75efcbc455adc7f7d12964"
    sha256 cellar: :any,                 ventura:        "28544643c863a0f913cbd0e9d24aef46f7e756e39e4e97da0d5b326997778b54"
    sha256 cellar: :any,                 monterey:       "190514467e7276e2ec20609c8f3be631dc10fe266db1374e520792cdb9cdd884"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a9b72dc288257ce69b25988750127f2a9e78e889b0d26de2d3eca1919e79a9b4"
  end

  depends_on "cmake" => :build
  depends_on "llvm"

  fails_with gcc: "5"

  def llvm
    deps.map(&:to_formula).find { |f| f.name.match?(/^llvm(@\d+)?$/) }
  end

  def install
    system "cmake", "-S", "enzyme", "-B", "build", "-DLLVM_DIR=#{llvm.opt_lib}/cmake/llvm", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      extern double __enzyme_autodiff(void*, double);
      double square(double x) {
        return x * x;
      }
      double dsquare(double x) {
        return __enzyme_autodiff(square, x);
      }
      int main() {
        double i = 21.0;
        printf("square(%.0f)=%.0f, dsquare(%.0f)=%.0f\\n", i, square(i), i, dsquare(i));
      }
    EOS

    ENV["CC"] = llvm.opt_bin/"clang"

    system ENV.cc, testpath/"test.c",
                        "-fplugin=#{lib/shared_library("ClangEnzyme-#{llvm.version.major}")}",
                        "-O1", "-o", "test"

    assert_equal "square(21)=441, dsquare(21)=42\n", shell_output("./test")
  end
end
