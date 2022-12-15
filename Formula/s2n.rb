class S2n < Formula
  desc "Implementation of the TLS/SSL protocols"
  homepage "https://github.com/aws/s2n-tls"
  url "https://github.com/aws/s2n-tls/archive/v1.3.31.tar.gz"
  sha256 "23cfb42f82cbe1ce94b59f3b1c1c8eb9d24af2a1ae4c8f854209ff88fddd3900"
  license "Apache-2.0"
  head "https://github.com/aws/s2n-tls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "783804619ecd9fecc6d862c2fa156b6b40449ccb9041cf52419957f728a12be6"
    sha256 cellar: :any,                 arm64_monterey: "afad7f7469c474f59bada71cead4b5e4f591ac939dc9983afbd6417a69e3873c"
    sha256 cellar: :any,                 arm64_big_sur:  "5057c967d0c09fe5373adfbceec71144fd49a04ee371d633cfe889061d281915"
    sha256 cellar: :any,                 ventura:        "cfa1e82ed695695618b494d879c2e7a1b2c10feb086e416a99a6e767d6266ab9"
    sha256 cellar: :any,                 monterey:       "bdc267649e0090ef58a2a5db090c59c197365e0b181a341f38b7b9eaf6e21ccd"
    sha256 cellar: :any,                 big_sur:        "d63d7c9d57a972514c40dda5c55ac862156afa435e8a99352dc6fafca82d76bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a159685a8de57ee3c67e5c6c10c056728a32795e0209be3ae29ee0fa68f45b06"
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
