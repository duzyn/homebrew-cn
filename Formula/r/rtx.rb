class Rtx < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://github.com/jdx/rtx"
  url "https://mirror.ghproxy.com/https://github.com/jdx/rtx/archive/refs/tags/v2023.11.7.tar.gz"
  sha256 "71de77bae00839e4484500214ff5f89ad94975ab1b2bd839345bbaac462ba2dc"
  license "MIT"
  head "https://github.com/jdx/rtx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "315291f3917aef8233f1292952dabbdf02f868d30692e46f9197690b56b7fb95"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e9e73125b2625f3942b425a33cad9677a0d2186ca1e38eed6fa493b95565d08d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "88ef3b4ccbdcbe89070d939baf193214ed93ef32564847ba30d6e9137a274be1"
    sha256 cellar: :any_skip_relocation, sonoma:         "0375acfbf8a808149d89033cb9ff229cefd89aaf4b8396fc42d33c8c0fb3bd22"
    sha256 cellar: :any_skip_relocation, ventura:        "f5a2c850d3c62e57e88359fec9f91b1632f2dfa0a8600ef75d7f46649f22378f"
    sha256 cellar: :any_skip_relocation, monterey:       "922978c5b19bc9ce97f0d51b0016d9785756ec103fece1a839ed4913825e1766"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "78d5010c20007449777234856811a3ab3e649ab5c11926d562d0ee42e843edea"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", "--features=brew", *std_cargo_args
    man1.install "man/man1/rtx.1"
    generate_completions_from_executable(bin/"rtx", "completion")
  end

  test do
    system "#{bin}/rtx", "install", "nodejs@18.13.0"
    assert_match "v18.13.0", shell_output("#{bin}/rtx exec nodejs@18.13.0 -- node -v")
  end
end
