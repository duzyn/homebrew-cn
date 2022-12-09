class S2n < Formula
  desc "Implementation of the TLS/SSL protocols"
  homepage "https://github.com/aws/s2n-tls"
  url "https://github.com/aws/s2n-tls/archive/v1.3.30.tar.gz"
  sha256 "b21d52fdfd52f7cf0c19084b8a43ef706bcfc89705fc5ec2baba2601cd6b53de"
  license "Apache-2.0"
  head "https://github.com/aws/s2n-tls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "dc0932bf63dac3354d6a6d21b3304c3bf2f07900f70143b91ecc52fdb736c28f"
    sha256 cellar: :any,                 arm64_monterey: "29cda278438462da8b956b5b03a214a67edd272634c2f1ef02c0a1c16af7542a"
    sha256 cellar: :any,                 arm64_big_sur:  "5e4fd1675696333ee699c0caeff7a2cf6960fb5d91e63e19c8bc49a50a6a398e"
    sha256 cellar: :any,                 ventura:        "9ca826d831213bd19acc20069a3074e89559595afb8baa1e14f2b9b1aa9b5fa4"
    sha256 cellar: :any,                 monterey:       "93b5e6e9e64f304e424055e069973b8265b750b0af9877261da1a1f8bd3dca40"
    sha256 cellar: :any,                 big_sur:        "306f042a10dc58ca8ccb414bd0f5fd8ec824119b2a44e94f98e1669c5fb50eab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b0d78cd5e2f39a183c5b280e98906fdc1c480e0cdebebeafa7b04dbf4748354f"
  end

  depends_on "cmake" => :build
  depends_on "openssl@3"

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
