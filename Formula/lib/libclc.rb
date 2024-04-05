class Libclc < Formula
  desc "Implementation of the library requirements of the OpenCL C programming language"
  homepage "https://libclc.llvm.org/"
  url "https://mirror.ghproxy.com/https://github.com/llvm/llvm-project/releases/download/llvmorg-18.1.3/libclc-18.1.3.src.tar.xz"
  sha256 "b117efb9a27ab923e03e565435f30ca8c5c1624d0832a09e32d14c3eb4995a7c"
  license "Apache-2.0" => { with: "LLVM-exception" }

  livecheck do
    url :stable
    regex(/^llvmorg[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "01e5f59c2191628a551a1deed5737123d674fd7d200535fe179e06b0640ecd2c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "01e5f59c2191628a551a1deed5737123d674fd7d200535fe179e06b0640ecd2c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "01e5f59c2191628a551a1deed5737123d674fd7d200535fe179e06b0640ecd2c"
    sha256 cellar: :any_skip_relocation, sonoma:         "01e5f59c2191628a551a1deed5737123d674fd7d200535fe179e06b0640ecd2c"
    sha256 cellar: :any_skip_relocation, ventura:        "01e5f59c2191628a551a1deed5737123d674fd7d200535fe179e06b0640ecd2c"
    sha256 cellar: :any_skip_relocation, monterey:       "01e5f59c2191628a551a1deed5737123d674fd7d200535fe179e06b0640ecd2c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "849d943985c0cb7782b14dbe595475757909228648baa0988b15c29fefcddd94"
  end

  depends_on "cmake" => :build
  depends_on "llvm" => [:build, :test]
  depends_on "spirv-llvm-translator" => :build

  def install
    llvm_spirv = Formula["spirv-llvm-translator"].opt_bin/"llvm-spirv"
    system "cmake", "-S", ".", "-B", "build",
                    "-DLLVM_SPIRV=#{llvm_spirv}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    inreplace share/"pkgconfig/libclc.pc", prefix, opt_prefix
  end

  test do
    clang_args = %W[
      -target nvptx--nvidiacl
      -c -emit-llvm
      -Xclang -mlink-bitcode-file
      -Xclang #{share}/clc/nvptx--nvidiacl.bc
    ]
    llvm_bin = Formula["llvm"].opt_bin

    (testpath/"add_sat.cl").write <<~EOS
      __kernel void foo(__global char *a, __global char *b, __global char *c) {
        *a = add_sat(*b, *c);
      }
    EOS

    system llvm_bin/"clang", *clang_args, "./add_sat.cl"
    assert_match "@llvm.sadd.sat.i8", shell_output("#{llvm_bin}/llvm-dis ./add_sat.bc -o -")
  end
end
