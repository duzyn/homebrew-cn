class Moarvm < Formula
  desc "VM with adaptive optimization and JIT compilation, built for Rakudo"
  homepage "https://moarvm.org"
  url "https://ghproxy.com/github.com/MoarVM/MoarVM/releases/download/2022.12/MoarVM-2022.12.tar.gz"
  sha256 "51c3e9c9a7a191c148f213b65ae1f4fcfe5d4b7c16c86300e9ee8e18eaa8becb"
  license "Artistic-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_ventura:  "6fc43306382629ef7ec2fa15c42ca906093996f3ba5a3c70b19d18927e67907c"
    sha256 arm64_monterey: "c33d6e42e77c897ed31ce2f18c5c6a8e8b707160a1f0a8e18c3dea2628dc4c12"
    sha256 arm64_big_sur:  "a39c90a995940e34016dd9524951e75796e6e82761be29d4b84e0ea70ecb03dc"
    sha256 ventura:        "26ccba25d90674158d130f5e59f28c45ca7fea13c08f1174519d76b15b07e4c6"
    sha256 monterey:       "d6a260da5e201b3710b291b235067c3e12d12cb4342ce62096b2a378c46f687f"
    sha256 big_sur:        "269be1fb61ffd7749068dfb92a8803c1d3c1844562239013abac1220da3f7aaa"
    sha256 x86_64_linux:   "ee1182df9db306e739b76f3ad9ccde7d03137affc0d4a76ad1612c78664ff164"
  end

  depends_on "pkg-config" => :build
  depends_on "libtommath"
  depends_on "libuv"
  depends_on "zstd"

  uses_from_macos "perl" => :build
  uses_from_macos "libffi"

  conflicts_with "rakudo-star", because: "rakudo-star currently ships with moarvm included"

  resource "nqp" do
    url "https://ghproxy.com/github.com/Raku/nqp/releases/download/2022.12/nqp-2022.12.tar.gz"
    sha256 "e5f7d13a0a4855be420c071cdaf004c7abd0984977863bd2828a5cf7de8459ad"
  end

  def install
    configure_args = %W[
      --c11-atomics
      --has-libffi
      --has-libtommath
      --has-libuv
      --optimize
      --pkgconfig=#{Formula["pkg-config"].opt_bin}/pkg-config
      --prefix=#{prefix}
    ]
    system "perl", "Configure.pl", *configure_args
    system "make", "realclean"
    system "make"
    system "make", "install"
  end

  test do
    testpath.install resource("nqp")
    out = Dir.chdir("src/vm/moar/stage0") do
      shell_output("#{bin}/moar nqp.moarvm -e 'for (0,1,2,3,4,5,6,7,8,9) { print($_) }'")
    end
    assert_equal "0123456789", out
  end
end
