class Tut < Formula
  desc "TUI for Mastodon with vim inspired keys"
  homepage "https://tut.anv.nu"
  url "https://github.com/RasmusLindroth/tut/archive/refs/tags/1.0.30.tar.gz"
  sha256 "404f1d6647920fc32fab02c92ee23ab4a7e2c7507d535669c4e5a29075d480b1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "55e4964d3876fd9270b4c138897ea8006938471e8ede0f108f324e0a045778a7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8a25234819b5a69988f17cf340b4c1d7537cc7be62ab63213ad36d770442dcef"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "556beb9166fc5d6bcfdaaa67a42cec8329150c201f74fef9178e35e7eeba8749"
    sha256 cellar: :any_skip_relocation, ventura:        "34fa8b7bf2bb3c4575de30b9cfb35dce4cbf7d7e576e41a09227bbe88667ffb7"
    sha256 cellar: :any_skip_relocation, monterey:       "c8d92127147a345aa187821fd6730707b42b68632e9d48aa662f14146e219d8f"
    sha256 cellar: :any_skip_relocation, big_sur:        "c23efc1a678a47cd9e769bda5a8455c2f68d0d003997e635fb2f564a32183020"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "874aadd4e63f7682a3f77f1ea1ca06a07ffa1d06e8fdf3eb1a8986e74473fbe7"
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
