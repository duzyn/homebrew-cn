class Edencommon < Formula
  desc "Shared library for Watchman and Eden projects"
  homepage "https://github.com/facebookexperimental/edencommon"
  url "https://ghproxy.com/https://github.com/facebookexperimental/edencommon/archive/refs/tags/v2023.10.30.00.tar.gz"
  sha256 "e692de0b6ddb97d6415c11e9ea349da30cc95a9aa9af0d2e70b52038862d69bd"
  license "MIT"
  revision 1
  head "https://github.com/facebookexperimental/edencommon.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c19417c4376398c0966002107a0724f4ccb9f914b380c64aa48304e9bd36beda"
    sha256 cellar: :any,                 arm64_ventura:  "2d9c7d369a1f8117f167e7d382fc1952df0e736bd2fdc05b123164b097cdaab5"
    sha256 cellar: :any,                 arm64_monterey: "2a0111138506e96d386365a817f8bd0f1e37e0a84ce24e0b9f688d923f9eb768"
    sha256 cellar: :any,                 sonoma:         "7a272537dc37584d178dc35c3a51f095924979abc182676890efc9bc0d3dca4a"
    sha256 cellar: :any,                 ventura:        "68f509a9950fad3c56d9e8c171f9bab43d67f4c1c969a45d3513441590b8d48b"
    sha256 cellar: :any,                 monterey:       "21f4277d2cc54524190f090c74af8119b007861adcbbf90a45c426f6b50673f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0aad44ff94f055cfb53eff5cf1c4c2e33aa10a44ce2f478145bd44d026121bd3"
  end

  depends_on "cmake" => :build
  depends_on "googletest" => :build
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"
  depends_on "libsodium"
  depends_on "openssl@3"

  def install
    # Fix "Process terminated due to timeout" by allowing a longer timeout.
    inreplace buildpath.glob("eden/common/{os,utils}/test/CMakeLists.txt"),
              /gtest_discover_tests\((.*)\)/,
              "gtest_discover_tests(\\1 DISCOVERY_TIMEOUT 60)"
    inreplace "eden/common/utils/test/CMakeLists.txt",
              /gtest_discover_tests\((.*)\)/,
              "gtest_discover_tests(\\1 DISCOVERY_TIMEOUT 60)"

    system "cmake", "-S", ".", "-B", "_build", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
    system "cmake", "--build", "_build"
    system "cmake", "--install", "_build"
  end

  test do
    (testpath/"test.cc").write <<~EOS
      #include <eden/common/utils/ProcessInfo.h>
      #include <cstdlib>
      #include <iostream>

      using namespace facebook::eden;

      int main(int argc, char **argv) {
        if (argc <= 1) return 1;
        int pid = std::atoi(argv[1]);
        std::cout << readProcessName(pid) << std::endl;
        return 0;
      }
    EOS

    system ENV.cxx, "-std=c++17", "-I#{include}", "test.cc",
                    "-L#{lib}", "-L#{Formula["folly"].opt_lib}",
                    "-L#{Formula["boost"].opt_lib}", "-L#{Formula["glog"].opt_lib}",
                    "-ledencommon_utils", "-lfolly", "-lboost_context-mt", "-lglog", "-o", "test"
    assert_match "ruby", shell_output("./test #{Process.pid}")
  end
end
