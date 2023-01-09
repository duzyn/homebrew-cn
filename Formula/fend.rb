class Fend < Formula
  desc "Arbitrary-precision unit-aware calculator"
  homepage "https://printfn.github.io/fend"
  url "https://github.com/printfn/fend/archive/refs/tags/v1.1.4.tar.gz"
  sha256 "6343013cedfb4000e9415b64f9f98f365c96d0c2186f912d562d4fc752a21207"
  license "MIT"
  head "https://github.com/printfn/fend.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f4c96fd8f4f97bb9a34ad3c883899d60393de6549c40817f8232ec8d343ae682"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "703e96551be78e1f3cfcfd1c139c5c1cea689dc21caadccd998384258cc392c7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8e1d61389848562a7732a364dc6294179a46d4329ec51af1c744e405ff9df9cc"
    sha256 cellar: :any_skip_relocation, ventura:        "343d4272d7437a6d560e11981c6f34c102b564bafea92829d42f07ac9eeaa81b"
    sha256 cellar: :any_skip_relocation, monterey:       "59c2877d5dfdf724125e8a21ab42bf906edd65161b13ce4eb8c2b097a6fb6098"
    sha256 cellar: :any_skip_relocation, big_sur:        "e8ee802e5f673bb92abf26be952ada2d5691e06669e80d2c7c895d79288d8108"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0b37374af5869aa28ec913082826d9c44af0ce3c57bfc1d5f71905dfa0374a83"
  end

  depends_on "pandoc" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
    system "./documentation/build.sh"
    man1.install "documentation/fend.1"
  end

  test do
    assert_equal "1000 m", shell_output("#{bin}/fend 1 km to m").strip
  end
end
