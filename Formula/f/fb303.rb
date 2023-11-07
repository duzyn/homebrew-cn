class Fb303 < Formula
  desc "Thrift functions for querying information from a service"
  homepage "https://github.com/facebook/fb303"
  url "https://ghproxy.com/https://github.com/facebook/fb303/archive/refs/tags/v2023.10.30.00.tar.gz"
  sha256 "aac921b0df5e6300e294657245a3b1d49663f58e7907f0aae68f60288a3b8c11"
  license "Apache-2.0"
  revision 1
  head "https://github.com/facebook/fb303.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f20da22b3c029a012d4b05c14b6c407d13f630e1599b0fa67fab57d6524d1c39"
    sha256 cellar: :any,                 arm64_ventura:  "95710750300fd60aeb86d2f498c07b76d626cd3a00973359f5ec516517e755d9"
    sha256 cellar: :any,                 arm64_monterey: "ea151fc3a1869bb9b22d291a12b325a6f107229204485c1e19d057fb22a0f92c"
    sha256 cellar: :any,                 sonoma:         "bf27c6a9254d74def227f1b41eee530a405287cf3cd540dde90263cb12980e61"
    sha256 cellar: :any,                 ventura:        "4bee72abaca7cb87a3b2ac6a2365ce8b724d52d7c5936174bb4d575669cbb9a3"
    sha256 cellar: :any,                 monterey:       "e2df425c6e793897c606bda52c4d83b219fcf943bca6fab6f1b054b47a261165"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c36f0d0f0fc058e0a6cc394add33e478707df7e1b9301d496ac74da7f09ccf06"
  end

  depends_on "cmake" => :build
  depends_on "fbthrift" => [:build, :test]
  depends_on "mvfst" => :build
  depends_on "fizz"
  depends_on "fmt"
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"
  depends_on "libsodium"
  depends_on "openssl@3"
  depends_on "wangle"

  fails_with gcc: "5" # C++17

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DPYTHON_EXTENSIONS=OFF",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include "fb303/thrift/gen-cpp2/BaseService.h"
      #include <iostream>
      int main() {
        auto service = facebook::fb303::cpp2::BaseServiceSvIf();
        std::cout << service.getGeneratedName() << std::endl;
        return 0;
      }
    EOS

    if Tab.for_formula(Formula["folly"]).built_as_bottle
      ENV.remove_from_cflags "-march=native"
      ENV.append_to_cflags "-march=#{Hardware.oldest_cpu}" if Hardware::CPU.intel?
    end

    ENV.append "CXXFLAGS", "-std=c++17"
    system ENV.cxx, *ENV.cxxflags.split, "test.cpp", "-o", "test",
                    "-I#{include}", "-I#{Formula["openssl@3"].opt_include}",
                    "-L#{lib}", "-lfb303_thrift_cpp",
                    "-L#{Formula["folly"].opt_lib}", "-lfolly",
                    "-L#{Formula["glog"].opt_lib}", "-lglog",
                    "-L#{Formula["fbthrift"].opt_lib}", "-lthriftprotocol", "-lthriftcpp2",
                    "-L#{Formula["boost"].opt_lib}", "-lboost_context-mt",
                    "-ldl"
    assert_equal "BaseService", shell_output("./test").strip
  end
end
