class Ncnn < Formula
  desc "High-performance neural network inference framework"
  homepage "https://github.com/Tencent/ncnn"
  url "https://github.com/Tencent/ncnn/archive/refs/tags/20221128.tar.gz"
  sha256 "d383d7640a6ce63181794fd3411acc0888daf0d13eabb9ea621b24ca5c810eb8"
  license "BSD-3-Clause"
  head "https://github.com/Tencent/ncnn.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "74f7d2655429c8b0f463e564fa65a1a222169620be58d399d1e1a8a92a87a0d3"
    sha256 cellar: :any,                 arm64_monterey: "7b4d13fef792e5f849ff9d7750bed27a0fc53706558359c8ae2e50ac0a7e4370"
    sha256 cellar: :any,                 arm64_big_sur:  "084406d549aa875443b26506dc0499b49083e2bb3452efc098ef75e375e3f1b5"
    sha256 cellar: :any,                 ventura:        "89b1454061731503d8cdeca11b393b750024b6028cb4d365243199fe96514c84"
    sha256 cellar: :any,                 monterey:       "a04771dbd8a2751363629201cebce8dc0b92c1130050c3dce764dfb546a8ca4a"
    sha256 cellar: :any,                 big_sur:        "d7ff1950a18f125e8edbc29d7bdd4b1bd4f75cd558dd4e52713df9c1794cc286"
    sha256 cellar: :any,                 catalina:       "dba2400e9fcb2e63c3699d3896ff9d61aa335ec1d1ed73479dbe529ac6839ae4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d717bbab9229468b54d1bd6cc8b182dd78a35365d8377652c3b250aa6bcd6666"
  end

  depends_on "cmake" => :build
  depends_on "protobuf"

  on_macos do
    depends_on "glslang" => :build
    depends_on "vulkan-headers" => [:build, :test]
    depends_on "libomp"
    depends_on "molten-vk"
  end

  def install
    ENV.cxx11

    args = std_cmake_args + %w[
      -DNCNN_SHARED_LIB=ON
      -DNCNN_BUILD_BENCHMARK=OFF
      -DNCNN_BUILD_EXAMPLES=OFF
    ]

    if OS.mac?
      args += %W[
        -DNCNN_SYSTEM_GLSLANG=ON
        -DGLSLANG_TARGET_DIR=#{Formula["glslang"].opt_lib/"cmake"}
        -DNCNN_VULKAN=ON
        -DVulkan_INCLUDE_DIR=#{Formula["molten-vk"].opt_include}
        -DVulkan_LIBRARY=#{Formula["molten-vk"].opt_lib/shared_library("libMoltenVK")}
      ]
    end

    inreplace "src/gpu.cpp", "glslang/glslang", "glslang"
    system "cmake", "-S", ".", "-B", "build", *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <ncnn/mat.h>

      int main(void) {
          ncnn::Mat myMat = ncnn::Mat(500, 500);
          myMat.fill(1);
          ncnn::Mat myMatClone = myMat.clone();
          myMat.release();
          myMatClone.release();
          return 0;
      }
    EOS

    system ENV.cxx, "test.cpp", "-std=c++11",
                    "-I#{Formula["vulkan-headers"].opt_include}", "-I#{include}", "-L#{lib}", "-lncnn",
                    "-o", "test"
    system "./test"
  end
end
