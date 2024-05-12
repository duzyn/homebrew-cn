class S2n < Formula
  desc "Implementation of the TLS/SSL protocols"
  homepage "https://github.com/aws/s2n-tls"
  url "https://mirror.ghproxy.com/https://github.com/aws/s2n-tls/archive/refs/tags/v1.4.14.tar.gz"
  sha256 "90cd0b7b1e5ebc7e40ba5f810cc24a4d604aa534fac7260dee19a35678e38659"
  license "Apache-2.0"
  head "https://github.com/aws/s2n-tls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "835dc4a4ce265a17d932b1ad86df1c4065280862d37dcdde9ee377c5ca94f6e0"
    sha256 cellar: :any,                 arm64_ventura:  "30f1e7cd2d328af3d7f79a779ba108c2553d1313be8cf30dc8b19e853c7128fc"
    sha256 cellar: :any,                 arm64_monterey: "962a595a9440396f4d77c6c28ca628d6d6f01b76386fc85f540a7075653c5f5a"
    sha256 cellar: :any,                 sonoma:         "87fc26fe2daa1c0dbf30fd56cde4658c33b6c49b8548025e36ec676a6ad7c517"
    sha256 cellar: :any,                 ventura:        "ef9704ccaa03515c8735dd97012148d51dc744c9bbb1cb58dee880de9262db0a"
    sha256 cellar: :any,                 monterey:       "7567bc8a01f5087cb5df0bc0977efdc7e43bf59422b5d18a22eaa11e467f53cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9ef1cb2e24b5658717775d7091c250b582bc39c1243ffa693079f3ee043a0e45"
  end

  depends_on "cmake" => :build
  depends_on "openssl@3"

  conflicts_with "aws-sdk-cpp", because: "both install s2n/unstable/crl.h"

  def install
    system "cmake", "-S", ".", "-B", "build/static", *std_cmake_args, "-DBUILD_SHARED_LIBS=OFF"
    system "cmake", "--build", "build/static"
    system "cmake", "--install", "build/static"

    system "cmake", "-S", ".", "-B", "build/shared", *std_cmake_args, "-DBUILD_SHARED_LIBS=ON"
    system "cmake", "--build", "build/shared"
    system "cmake", "--install", "build/shared"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <assert.h>
      #include <s2n.h>
      int main() {
        assert(s2n_init() == 0);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{opt_lib}", "-ls2n", "-o", "test"
    ENV["S2N_DONT_MLOCK"] = "1" if OS.linux?
    system "./test"
  end
end
