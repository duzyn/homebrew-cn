class Fb303 < Formula
  desc "Thrift functions for querying information from a service"
  homepage "https://github.com/facebook/fb303"
  url "https://github.com/facebook/fb303/archive/v2022.11.28.00.tar.gz"
  sha256 "b41bfe90d1c0ff010b24d73ec81474780e1f49449e49bfc85caae89e8166f6c0"
  license "Apache-2.0"
  head "https://github.com/facebook/fb303.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "54978f465d8e44ee4c8a10161aef6091b0e272bba834efa435e1cf5734e6f6f8"
    sha256 cellar: :any,                 arm64_monterey: "26bca2216bd2e8ea6bc49f1520b56e5f67c9900be77aeb928890863863338fc8"
    sha256 cellar: :any,                 arm64_big_sur:  "4045b82f2fa5fd00fb3e1a6ac3787c2bef7867a0d1e48da47010faa95eb2429c"
    sha256 cellar: :any,                 monterey:       "1f0252a20a2fd0f949b2a35cf988d6476e00d7f992851aa00e8413d7d717c926"
    sha256 cellar: :any,                 big_sur:        "eed02fb227ef939cdd46a852b8604a2d09f953859464c129270603ff09510829"
    sha256 cellar: :any,                 catalina:       "3e7a5079ffefb8245de8d99477f70000f827bc42881be325c870b25a74bab26d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a00ab6326cf38128ce83ea441b7cf21fdd1379b33e4c5f62a16b151b7d8c6347"
  end

  depends_on "cmake" => :build
  depends_on "fbthrift"
  depends_on "fizz"
  depends_on "fmt"
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"
  depends_on "openssl@1.1"
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
                    "-I#{include}", "-I#{Formula["openssl@1.1"].opt_include}",
                    "-L#{lib}", "-lfb303_thrift_cpp",
                    "-L#{Formula["folly"].opt_lib}", "-lfolly",
                    "-L#{Formula["glog"].opt_lib}", "-lglog",
                    "-L#{Formula["fbthrift"].opt_lib}", "-lthriftprotocol", "-lthriftcpp2",
                    "-L#{Formula["boost"].opt_lib}", "-lboost_context-mt",
                    "-ldl"
    assert_equal "BaseService", shell_output("./test").strip
  end
end
