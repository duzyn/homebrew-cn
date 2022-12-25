class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://github.com/EnzymeAD/Enzyme/archive/v0.0.46.tar.gz", using: :homebrew_curl
  sha256 "fa0e3905ad8f4fa719fabbdb3f535704467dd79aad2f0fd59a97669d4af492bd"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "4bfa187d92c382a199419db1d9a6519193a907e8a00508799c0583b0f8a5bf66"
    sha256 cellar: :any,                 arm64_monterey: "f520c7036a43368f13e39071295bb3ef732a68d091aa3d3e8128c0bf8f7c8437"
    sha256 cellar: :any,                 arm64_big_sur:  "4bbd219e827237b10d029532f47e427bee404f43908b2c8c68733e2dd3bc1fad"
    sha256 cellar: :any,                 ventura:        "02d9c76a64934b83b6148b982c36fa83464ded6031dd58edc4b99abd4d6b3554"
    sha256 cellar: :any,                 monterey:       "059680324c83a32cb0d275d68192b169eb36770918aeb2ebde204e8d79b7ba4b"
    sha256 cellar: :any,                 big_sur:        "bcba0a1c57b73c9603c262db4643a064c508e82ce0d2d03ddf0d0937a1bc4cd2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4b7bd7333bc508ea6d127c11a1c171e4e4c5bb98cbb0c2baed8b47aabaa79af4"
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

    opt = llvm.opt_bin/"opt"
    ENV["CC"] = llvm.opt_bin/"clang"

    # `-Xclang -no-opaque-pointers` is a transitional flag for LLVM 15, and will
    # likely be need to removed in LLVM 16. See:
    # https://llvm.org/docs/OpaquePointers.html#version-support
    system ENV.cc, "-v", testpath/"test.c", "-S", "-emit-llvm", "-o", "input.ll", "-O2",
                   "-fno-vectorize", "-fno-slp-vectorize", "-fno-unroll-loops",
                   "-Xclang", "-no-opaque-pointers"
    system opt, "input.ll", "--enable-new-pm=0",
                "-load=#{opt_lib/shared_library("LLVMEnzyme-#{llvm.version.major}")}",
                "--enzyme-attributor=0", "-enzyme", "-o", "output.ll", "-S"
    system ENV.cc, "output.ll", "-O3", "-o", "test"

    assert_equal "square(21)=441, dsquare(21)=42\n", shell_output("./test")
  end
end
