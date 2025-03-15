class Open62541 < Formula
  desc "Open source implementation of OPC UA"
  homepage "https://open62541.org/"
  url "https://mirror.ghproxy.com/https://github.com/open62541/open62541/archive/refs/tags/v1.4.11.tar.gz"
  sha256 "6fd1b5db655ee13e216958470481bd0307482c4ecc2bddbdee2cfc3a5438bbf6"
  license "MPL-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "37d4156488471063b41d16aba5fb43c9cb7db954cfdd761b742ffd9d20640c03"
    sha256 cellar: :any,                 arm64_sonoma:  "31db47f4df02842c1f1ae49de2818d891f26d7772e5cf8d4f56f4856bcad4f4c"
    sha256 cellar: :any,                 arm64_ventura: "d0e8e4e16aab6238c9deaa2415b596b644d11ea6860846bf8f07d69d45c60bb3"
    sha256 cellar: :any,                 sonoma:        "0f2c9617a3ba07d2c9e88f5af01ee5965200b4ac011e1387f79d8df54097cc8a"
    sha256 cellar: :any,                 ventura:       "2936515f49cdb435ec287f81971c0a8da2c94f813c4ada54e14cd05592eb6d66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "88bde549f8815b5f598ea9bb8ce79382cee5f8ebb0d1b3d9aa831da5f6f36f51"
  end

  depends_on "cmake" => :build
  uses_from_macos "python" => :build

  def install
    cmake_args = %w[
      -DBUILD_SHARED_LIBS=ON
      -DUA_ENABLE_DISCOVERY=ON
      -DUA_ENABLE_HISTORIZING=ON
      -DUA_ENABLE_JSON_ENCODING=ON
    ]
    system "cmake", "-S", ".", "-B", "build", *cmake_args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <open62541/client_config_default.h>
      #include <assert.h>

      int main(void) {
        UA_Client *client = UA_Client_new();
        assert(client != NULL);
        return 0;
      }
    C
    system ENV.cc, "./test.c", "-o", "test", "-I#{include}", "-L#{lib}", "-lopen62541"
    system "./test"
  end
end
