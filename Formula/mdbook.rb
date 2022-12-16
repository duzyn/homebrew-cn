class Mdbook < Formula
  desc "Create modern online books from Markdown files"
  homepage "https://rust-lang.github.io/mdBook/"
  url "https://github.com/rust-lang/mdBook/archive/v0.4.24.tar.gz"
  sha256 "fe291fb8eea8afece79d83c465f4e9ae2f0094aca0fb11ab2eb34601b436895f"
  license "MPL-2.0"
  head "https://github.com/rust-lang/mdBook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fa483c90c15666bd75843aa46e71ce2c0a9631649d7e4a26942f29e1fdbedb36"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "417afc5dcdccd40959fa97466c4a335a55b54ed1e741989b4905ceca2a91cb5e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8db30020ec08c0af4db09b281879fad2e28de6f03e2aee9db033b0f375751042"
    sha256 cellar: :any_skip_relocation, ventura:        "576396e65b8e6bd23ff503aa0da1587eb1b1e3ae5425afde59ad43100397ce60"
    sha256 cellar: :any_skip_relocation, monterey:       "aa9c01110f33d6bb9bb6a317187bb079dafec9d9e06e0e9d9593fff2dfa289ce"
    sha256 cellar: :any_skip_relocation, big_sur:        "4c1ffb89ccc7fe7998a6c0f6e874469209c922191590d86cd93622255e382769"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a9fedad2eca80e5fec6560ba37a7372353cdbecc22e2d66fb2c0e1a829bf825f"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # simulate user input to mdbook init
    system "sh", "-c", "printf \\n\\n | #{bin}/mdbook init"
    system bin/"mdbook", "build"
  end
end
