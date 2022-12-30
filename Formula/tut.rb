class Tut < Formula
  desc "TUI for Mastodon with vim inspired keys"
  homepage "https://tut.anv.nu"
  url "https://github.com/RasmusLindroth/tut/archive/refs/tags/1.0.31.tar.gz"
  sha256 "dc64e8ae81d87aad156a1a23b40c974c2dd4326cfe46ac149df30576305182a5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2cb78ca98dc8babe320f5e4e63dc3995a84c9a4004029566da7184f382689efc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "675328269f05265467f374497f66abb5561400fe672a6f677b09fc26555f0941"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "af279e09311c85896bedb3d5c8ac237380779059f1776be4cd412321c5830c50"
    sha256 cellar: :any_skip_relocation, ventura:        "622b7a22c1d648c724f0a86101c633b47bda303dc7f49011b580178b72bbb9b5"
    sha256 cellar: :any_skip_relocation, monterey:       "d10390e81541a16b2d208687a9909e63b1f0e8ce064a55354ebd18e73797b6f2"
    sha256 cellar: :any_skip_relocation, big_sur:        "ce639607b2dff8c836327aa28eb0b4e05a8aa92f80ff6436010c73f086b79a72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ab6823c0ee7d7732c406dd59e6abbbf630ef4fb9ba8d15776c698885659c7f4e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tut --version")
    assert_match "Instance:", pipe_output("#{bin}/tut --new-user 2> /dev/null")
  end
end
