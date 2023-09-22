class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  # TODO: Check if we can use unversioned `llvm` at version bump.
  url "https://ghproxy.com/https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.84.tar.gz", using: :homebrew_curl
  sha256 "1615288f06de51372c3500f77656b155dc42a6dec34e288dd0856cbd376b464c"
  license "Apache-2.0" => { with: "LLVM-exception" }
  revision 1
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "b61a43b77df24abc019abe9cf380ada803626c48133fcf3b7d6207700b59a77f"
    sha256 cellar: :any,                 arm64_monterey: "d5dd7531ab46627a03fe69f3bac61269d2425fb13ad1467261a6df317c5d6c04"
    sha256 cellar: :any,                 arm64_big_sur:  "5b46f2ae3dd6ce5d9885fcbbace20d53969b93f0499eaacd7cf93bf23d53fde2"
    sha256 cellar: :any,                 ventura:        "b798111123f97c63b8484fdb430661b5515a2861b9987ae2cf1343d19cda940d"
    sha256 cellar: :any,                 monterey:       "7d3ccbc9c8b74a7c21be3a1042cd39c0f00b0916bb0990b1cb70052137187558"
    sha256 cellar: :any,                 big_sur:        "b361a34b4a3544546d112db8e63d394c358413108e534b6123c4d52a7c1e8248"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cf77f963f3533296408d9dcb677120f1ed6e97125d70f3528357169f67648aa3"
  end

  depends_on "cmake" => :build
  depends_on "llvm@16"

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
