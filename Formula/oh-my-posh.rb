class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v12.36.0.tar.gz"
  sha256 "b4721bc024e6e9eebaa9a4df9448a296175afb5d67e19d1d2e332b9bbb0fa186"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "202a9b127db5e1cb1957abc09b24682a4a0ed27fd2a1f6f78eaedb485ee622ec"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bb56cca1a07f0c0c92368f7483de8427ff1c04d00ad542cb5edfd9fed2594aba"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2db897820a7e6552295e49174bcfa5f02952b7e2ec5e2c7f200fb900e7077b83"
    sha256 cellar: :any_skip_relocation, ventura:        "3dd2437df83822c8d7c6caf214341bb317ba7c09df8409186442e6233f5feb5e"
    sha256 cellar: :any_skip_relocation, monterey:       "0078287fc0fcc1b0d037a11372e8e44ca08fbe67fb795d8c1046fd8477077fe9"
    sha256 cellar: :any_skip_relocation, big_sur:        "19e9d6734bb9ede51fcf08f9fa66c9ea8eda3047229adb2646997d5d6aa10ba7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "158e56c2ac91d7ea97ad291661e55df78e00d419a01ff24a91cd807545567023"
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
