class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://mirror.ghproxy.com/https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.191.tar.gz"
  sha256 "5832f70fdbebc922c45da9e1d49985d96b91d54d12eac8e3f96aee9d3b09eb86"
  license "Apache-2.0" => { with: "LLVM-exception" }
  revision 1
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "69959f569e07029ae82b4fe17a98417f200000bd7c414535242780bc113fece2"
    sha256 cellar: :any,                 arm64_sonoma:  "1ec0417ae4179cffa6757707f095e6173be5890f647e1368c4874278214efd91"
    sha256 cellar: :any,                 arm64_ventura: "d3d5e5248586c35809a6d5311e979e58fd249b89f3676af719a793a969e1b62f"
    sha256 cellar: :any,                 ventura:       "9900d1f9a2a6276b3697b5d977b888230cf473b45d5ac4eb9eafe9fa0a47843f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a479085c88737115781d1bb20629f2d189e7932e52202dd2d5e695ca190dfe7d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dada0144e13fc199f5d470b784964e6bfc588a7f0b928f3053ec43e978250a83"
  end

  depends_on "cmake" => :build
  depends_on "llvm"

  def llvm
    deps.map(&:to_formula).find { |f| f.name.match?(/^llvm(@\d+)?$/) }
  end

  def install
    system "cmake", "-S", "enzyme", "-B", "build", "-DLLVM_DIR=#{llvm.opt_lib}/cmake/llvm", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
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
    C

    ENV["CC"] = llvm.opt_bin/"clang"

    system ENV.cc, testpath/"test.c",
                        "-fplugin=#{lib/shared_library("ClangEnzyme-#{llvm.version.major}")}",
                        "-O1", "-o", "test"

    assert_equal "square(21)=441, dsquare(21)=42\n", shell_output("./test")
  end
end
