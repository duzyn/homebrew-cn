class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v12.28.2.tar.gz"
  sha256 "2afb623fb2ac6b7d5a072e877456f44bc7701a1403983a4541e1e35e43ab8956"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5186f56918ff61dc65239f48baa014e20a897519b48970ccdc0f43f77ecb1c31"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d33683138ecec07577d29b54efc1e204f89ddd45eaeff7266edb7f181426af81"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8eb892bbaeb3d5e8bb21199b7809823e7034d303e38f3e5fd4cea97eff19045d"
    sha256 cellar: :any_skip_relocation, ventura:        "c14d138efb069289de3fd9c91802868782d914778014af2ad3cb7aeaf377f7a1"
    sha256 cellar: :any_skip_relocation, monterey:       "685656cf84c22e673f1d1259dbc3836b85c8778d07880fdb7dead94d4a213411"
    sha256 cellar: :any_skip_relocation, big_sur:        "cc4c2201c006daa21bce913a647fa34aaf54a54b0e922c30144d2d95ea65185f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "956a2f61035ce48de87084bdcc5c910bb9e835516a837dfa03dfc1bde8b9b8cb"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.Version=#{version}
    ]
    cd "src" do
      system "go", "build", *std_go_args(ldflags: ldflags)
    end

    prefix.install "themes"
    pkgshare.install_symlink prefix/"themes"
  end

  test do
    assert_match "oh-my-posh", shell_output("#{bin}/oh-my-posh --init --shell bash")
  end
end
