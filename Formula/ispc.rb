class Ispc < Formula
  desc "Compiler for SIMD programming on the CPU"
  homepage "https://ispc.github.io"
  url "https://github.com/ispc/ispc/archive/v1.18.1.tar.gz"
  sha256 "5b004c121e7a39c8654bb61930a240e4bd3e432a80d851c6281fae49f9aca7b7"
  license "BSD-3-Clause"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "71d036db4d1c72e0d482b6319ae80b2f2b689d193206f062d0e5d5be79fba506"
    sha256 cellar: :any,                 arm64_monterey: "ebbb9f84e98e02d9d48c8edbbcbc441ededec14a275a02dc50159442838d8d46"
    sha256 cellar: :any,                 arm64_big_sur:  "2f0b43f9129c4f8612b6ec3733fa33a9481716f5c4fc64722a0484e2faf29490"
    sha256 cellar: :any,                 ventura:        "c9acd44951ee26fde637a827891ca2723d40504e387836bac49652249a330743"
    sha256 cellar: :any,                 monterey:       "74cc731b62d211f510f3186c9cfcac8f9115320e4c818d6e4a53fa3b337dc2df"
    sha256 cellar: :any,                 big_sur:        "c767f2a66574d1f4ec414facdd0406f81e9efdda8be02ced32ab32a3c8732d36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "568d7315e62e78e6556ce76831c39638034c0497eed5de3176c200d139324126"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "flex" => :build
  depends_on "python@3.11" => :build
  depends_on "llvm@14"

  fails_with gcc: "5"

  def llvm
    deps.map(&:to_formula).find { |f| f.name.match? "^llvm" }
  end

  def install
    # Force cmake to use our compiler shims instead of bypassing them.
    inreplace "CMakeLists.txt", "set(CMAKE_C_COMPILER \"clang\")", "set(CMAKE_C_COMPILER \"#{ENV.cc}\")"
    inreplace "CMakeLists.txt", "set(CMAKE_CXX_COMPILER \"clang++\")", "set(CMAKE_CXX_COMPILER \"#{ENV.cxx}\")"

    # Disable building of i686 target on Linux, which we do not support.
    inreplace "cmake/GenerateBuiltins.cmake", "set(target_arch \"i686\")", "return()" unless OS.mac?

    args = std_cmake_args + %W[
      -DISPC_INCLUDE_EXAMPLES=OFF
      -DISPC_INCLUDE_TESTS=OFF
      -DISPC_INCLUDE_UTILS=OFF
      -DLLVM_TOOLS_BINARY_DIR='#{llvm.opt_bin}'
      -DISPC_NO_DUMPS=ON
      -DARM_ENABLED=#{Hardware::CPU.arm? ? "ON" : "OFF"}
    ]

    mkdir "build" do
      system "cmake", *args, ".."
      system "make"
      system "make", "install"
    end
  end

  test do
    (testpath/"simple.ispc").write <<~EOS
      export void simple(uniform float vin[], uniform float vout[], uniform int count) {
        foreach (index = 0 ... count) {
          float v = vin[index];
          if (v < 3.)
            v = v * v;
          else
            v = sqrt(v);
          vout[index] = v;
        }
      }
    EOS

    if Hardware::CPU.arm?
      arch = "aarch64"
      target = "neon"
    else
      arch = "x86-64"
      target = "sse2"
    end
    system bin/"ispc", "--arch=#{arch}", "--target=#{target}", testpath/"simple.ispc",
      "-o", "simple_ispc.o", "-h", "simple_ispc.h"

    (testpath/"simple.cpp").write <<~EOS
      #include "simple_ispc.h"
      int main() {
        float vin[9], vout[9];
        for (int i = 0; i < 9; ++i) vin[i] = static_cast<float>(i);
        ispc::simple(vin, vout, 9);
        return 0;
      }
    EOS
    system ENV.cxx, "-I#{testpath}", "-c", "-o", testpath/"simple.o", testpath/"simple.cpp"
    system ENV.cxx, "-o", testpath/"simple", testpath/"simple.o", testpath/"simple_ispc.o"

    system testpath/"simple"
  end
end
