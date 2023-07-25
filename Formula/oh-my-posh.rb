class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghproxy.com/https://github.com/JanDeDobbeleer/oh-my-posh/archive/v18.0.0.tar.gz"
  sha256 "c41675c5a180642eed69bff109c6919b498936d315d7771f83b27de7b64f38bd"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2dbf782ffcf655698ffcb58f05e936f482195db82579683c62e1f7ed347f2721"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ef99f313d979e2b03780300a92cf3336058a5411e5b92bc39dc373e949446482"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0c87a1c3aaee904a9e57c6bb024813551823247684a0c4a9e921effc5f6d2d3e"
    sha256 cellar: :any_skip_relocation, ventura:        "b7f0af173c6dc6c99b2e9b1fe7f33585ab7e1e0022451125bf92474010a79ac4"
    sha256 cellar: :any_skip_relocation, monterey:       "114f1f8e5b758abefd8774b3389d900a4ee812db4dbfb4eab966b732f6d71db7"
    sha256 cellar: :any_skip_relocation, big_sur:        "761573dbd83d997aac748248a123fef7b222b0f83e98a6925cc427a359fe1b85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4f131054a2a1ba28e70be135ead0428133ef445bd3e9bc026e3652f29afaed5d"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/jandedobbeleer/oh-my-posh/src/build.Version=#{version}
      -X github.com/jandedobbeleer/oh-my-posh/src/build.Date=#{time.iso8601}
    ]
    cd "src" do
      system "go", "build", *std_go_args(ldflags: ldflags)
    end

    prefix.install "themes"
    pkgshare.install_symlink prefix/"themes"
  end

  test do
    assert_match "oh-my-posh", shell_output("#{bin}/oh-my-posh --init --shell bash")
    assert_match version.to_s, shell_output("#{bin}/oh-my-posh --version")
  end
end
