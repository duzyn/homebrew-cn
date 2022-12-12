class Mcfly < Formula
  desc "Fly through your shell history"
  homepage "https://github.com/cantino/mcfly"
  url "https://github.com/cantino/mcfly/archive/v0.7.0.tar.gz"
  sha256 "11b88dcf0770fb5f6394d1f15225330ca5da27610d6a2764903b8d79f9062412"
  license "MIT"
  head "https://github.com/cantino/mcfly.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ca7130975f99dd894a1353ec889e0fe958adbed33eca9c4f7ca0a7ecd625c8b0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "90a8ce1d73a673f2cffe746a54b6b202bf00466910de92196eebbb01c5133fb9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3e443adb5bcaf77ce53f4359d8b76cf760f4007bec0c8ac72045a84ea495da1b"
    sha256 cellar: :any_skip_relocation, ventura:        "8729eb0e5d20307a4e8711d5482a426eca1e3fdc248627afb98c8848326fded3"
    sha256 cellar: :any_skip_relocation, monterey:       "37d992cd851df92ff652413f397f162f86d4b548de627cb50b96b5a8b964da04"
    sha256 cellar: :any_skip_relocation, big_sur:        "b7529119d95ce8a773a2da17d0b545076fb1454e1cfce88b7445815c8d014ab6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "22cfbe983d967729b4c2a940dfe02b72176801d1763b12a8d3118e7042beca46"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "mcfly_prompt_command", shell_output("#{bin}/mcfly init bash")
    assert_match version.to_s, shell_output("#{bin}/mcfly --version")
  end
end
