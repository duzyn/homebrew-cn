class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https://github.com/facebook/folly"
  url "https://ghproxy.com/https://github.com/facebook/folly/archive/refs/tags/v2023.10.30.00.tar.gz"
  sha256 "18ec1ae678187b5fc38a975e10d9fa981d1da5d4b80b16b67b8407d3db11388c"
  license "Apache-2.0"
  revision 1
  head "https://github.com/facebook/folly.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "4a7e810dc4710f51d06d16342b1a3b791f9ec01444e3062f2c43f9ee0f13e6a3"
    sha256 cellar: :any,                 arm64_ventura:  "31264338d4813fc291246841b476b464c44b2eae078916088a9f2b919e77cedb"
    sha256 cellar: :any,                 arm64_monterey: "4ff6426bc5d0a1d3d328105f89be83d4a4e8fd7a25102c20f7d533b6e5bf922d"
    sha256 cellar: :any,                 sonoma:         "cceb68f5608f5601df4344dae9963033aa02275277ab2c5bd3b41300957973a6"
    sha256 cellar: :any,                 ventura:        "587a9f691559fe20a77c39730dc73c39fee211cae5e884da9b021c9d2cde60d3"
    sha256 cellar: :any,                 monterey:       "e33bd8c8751e5a3a58c5d6f2e6ce2019c062b786455391113040ad488d177160"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6179995cbce6e1e76c1634a6fafb47db15d18d2240a495fdcd6aff78f4457af2"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
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

  on_macos do
    depends_on "llvm" if DevelopmentTools.clang_build_version <= 1100
  end

  fails_with :clang do
    build 1100
    # https://github.com/facebook/folly/issues/1545
    cause <<-EOS
      Undefined symbols for architecture x86_64:
        "std::__1::__fs::filesystem::path::lexically_normal() const"
    EOS
  end

  fails_with gcc: "5"

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

    (testpath/"test.cc").write <<~EOS
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
    EOS
    system ENV.cxx, "-std=c++14", "test.cc", "-I#{include}", "-L#{lib}",
                    "-lfolly", "-o", "test"
    system "./test"
  end
end
