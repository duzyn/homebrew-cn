class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https://github.com/facebook/folly"
  url "https://mirror.ghproxy.com/https://github.com/facebook/folly/archive/refs/tags/v2025.02.10.00.tar.gz"
  sha256 "320e1e1408d367c6963cf335ece7785b644bc014c23bae89f8e5d3fc6b3bb144"
  license "Apache-2.0"
  head "https://github.com/facebook/folly.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "397a0c94241467f89aaee43bbbd74c22aefcbc47a78fc7eee44e01318ecb3318"
    sha256 cellar: :any,                 arm64_sonoma:  "a03b158dc381584da44a04cfdf5511e812c88a980c383e9510255836615e2fb6"
    sha256 cellar: :any,                 arm64_ventura: "8b373b7ac5f0c5ef5a6455208b879cc3c66075f6e4fd43f69c748bff0c29edbb"
    sha256 cellar: :any,                 sonoma:        "aa370dd7617e3ea4edbd180ab1483f54dee42c2133e37b13b60cb8ec8f65e52c"
    sha256 cellar: :any,                 ventura:       "259619a277b3ca6ddd91c0de23b5a95483bfc1f2e0541ef326b4c78c3b40df69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "88e61292605ef9415b577f0c7899fb5b8ccd8b8e45ec16a540c84a70511d80bc"
  end

  depends_on "cmake" => :build
  depends_on "fast_float" => :build
  depends_on "pkgconf" => :build
  depends_on "boost"
  depends_on "double-conversion"
  depends_on "fmt"
  depends_on "gflags"
  depends_on "glog"
  depends_on "libevent"
  depends_on "libsodium"
  depends_on "lz4"
  depends_on "openssl@3"
  depends_on "snappy"
  depends_on "xz"
  depends_on "zstd"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  on_macos do
    depends_on "llvm" if DevelopmentTools.clang_build_version <= 1100
  end

  fails_with :clang do
    build 1100
    # https://github.com/facebook/folly/issues/1545
    cause <<~EOS
      Undefined symbols for architecture x86_64:
        "std::__1::__fs::filesystem::path::lexically_normal() const"
    EOS
  end

  def install
    ENV.llvm_clang if OS.mac? && (DevelopmentTools.clang_build_version <= 1100)

    args = %W[
      -DCMAKE_LIBRARY_ARCHITECTURE=#{Hardware::CPU.arch}
      -DFOLLY_USE_JEMALLOC=OFF
    ]

    system "cmake", "-S", ".", "-B", "build/shared",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    *args, *std_cmake_args
    system "cmake", "--build", "build/shared"
    system "cmake", "--install", "build/shared"

    system "cmake", "-S", ".", "-B", "build/static",
                    "-DBUILD_SHARED_LIBS=OFF",
                    *args, *std_cmake_args
    system "cmake", "--build", "build/static"
    lib.install "build/static/libfolly.a", "build/static/folly/libfollybenchmark.a"
  end

  test do
    # Force use of Clang rather than LLVM Clang
    ENV.clang if OS.mac?

    (testpath/"test.cc").write <<~CPP
      #include <folly/FBVector.h>
      int main() {
        folly::fbvector<int> numbers({0, 1, 2, 3});
        numbers.reserve(10);
        for (int i = 4; i < 10; i++) {
          numbers.push_back(i * 2);
        }
        assert(numbers[6] == 12);
        return 0;
      }
    CPP
    system ENV.cxx, "-std=c++17", "test.cc", "-I#{include}", "-L#{lib}",
                    "-lfolly", "-o", "test"
    system "./test"
  end
end
