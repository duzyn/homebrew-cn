class Secp256k1 < Formula
  desc "Optimized C library for EC operations on curve secp256k1"
  homepage "https://github.com/bitcoin-core/secp256k1"
  url "https://github.com/bitcoin-core/secp256k1/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "6cb0fd596e6b1a671f96e9ed7e65a047960def73de024e7b39f45a78ab4fc8df"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "774773baaaa4540d4fda3ccafda45b9fb4b15dd2d53fa367e78e23cd880eef3b"
    sha256 cellar: :any,                 arm64_monterey: "585cef2cf391256b0441142c7dfa629033c7718731346b5205f232ab0bee6bed"
    sha256 cellar: :any,                 arm64_big_sur:  "1efb6ef9892ea80e565aba659a7e57cc5048dee059d30d5d54edab518c62a939"
    sha256 cellar: :any,                 ventura:        "5c692c1935df4965afff8bb13de16046279dbfabf4db0b2c9564e55135dc3dce"
    sha256 cellar: :any,                 monterey:       "21ae567546e80433d73f5f4f4a8d1628fee0e322d9b232a5d3a0acaa8ba9ebd1"
    sha256 cellar: :any,                 big_sur:        "c24b600b5dc500808db84584a2158d2c28ade3f910e99e9c5e9875576f5932d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f80abdbf822a5877ad7103bccdd5a4afe098b7fed786ef1f8f3e6c4671fa683e"
  end

  depends_on "autoconf" => [:build]
  depends_on "automake" => [:build]
  depends_on "libtool" => [:build]

  def install
    system "./autogen.sh"
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <secp256k1.h>
      int main() {
        secp256k1_context* ctx = secp256k1_context_create(SECP256K1_CONTEXT_NONE);
        secp256k1_context_destroy(ctx);
        return 0;
      }
    EOS
    system ENV.cc, "test.c",
                   "-L#{lib}", "-lsecp256k1",
                   "-o", "test"
    system "./test"
  end
end
