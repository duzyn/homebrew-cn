class Fizz < Formula
  desc "C++14 implementation of the TLS-1.3 standard"
  homepage "https://github.com/facebookincubator/fizz"
  url "https://ghproxy.com/https://github.com/facebookincubator/fizz/releases/download/v2023.10.30.00/fizz-v2023.10.30.00.tar.gz"
  sha256 "5a33aa99d8dccc1daa7eef763c72e00ac471ecbcd832593078e7d93dcb143bfd"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/facebookincubator/fizz.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "2ef5f111a87d9e1d9c097e58839dece3528c28fb5f098abfa46de57a72c647df"
    sha256 cellar: :any,                 arm64_ventura:  "17ef45c82a409d41bc0eaba45703b3058ddf39e90ee24ba458378c340602733d"
    sha256 cellar: :any,                 arm64_monterey: "6a5649dd6e47a8c9ee36e9223a127d7f23add26fab0f825f530476abc8d3288f"
    sha256 cellar: :any,                 sonoma:         "38fc0118bb3c626d6e56f513f3b589bc345ceaf3ca975fc76444aca30863d7fc"
    sha256 cellar: :any,                 ventura:        "d08e217bbfd200959a358b9125752d865409961b89086c71f68adc6f354b7c48"
    sha256 cellar: :any,                 monterey:       "459eb58222d31dae0cc4d24ed18d5880fc0f9fdd32ec6ac224665a5cdaefe275"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "67f82b72f07343711d186e88fcda9e0c779ca60743e21c9715c4b9cc0de447dc"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "double-conversion"
  depends_on "fmt"
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"
  depends_on "libevent"
  depends_on "libsodium"
  depends_on "lz4"
  depends_on "openssl@3"
  depends_on "snappy"
  depends_on "zstd"

  fails_with gcc: "5"

  def install
    system "cmake", "-S", "fizz", "-B", "build",
                    "-DBUILD_TESTS=OFF",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <fizz/client/AsyncFizzClient.h>
      #include <iostream>

      int main() {
        auto context = fizz::client::FizzClientContext();
        std::cout << toString(context.getSupportedVersions()[0]) << std::endl;
      }
    EOS
    system ENV.cxx, "-std=c++17", "test.cpp", "-o", "test",
                    "-I#{include}",
                    "-I#{Formula["openssl@3"].opt_include}",
                    "-L#{lib}", "-lfizz",
                    "-L#{Formula["folly"].opt_lib}", "-lfolly",
                    "-L#{Formula["gflags"].opt_lib}", "-lgflags",
                    "-L#{Formula["glog"].opt_lib}", "-lglog",
                    "-L#{Formula["libevent"].opt_lib}", "-levent",
                    "-L#{Formula["libsodium"].opt_lib}", "-lsodium",
                    "-L#{Formula["openssl@3"].opt_lib}", "-lcrypto", "-lssl"
    assert_match "TLS", shell_output("./test")
  end
end
