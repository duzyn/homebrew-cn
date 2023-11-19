class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://mirror.ghproxy.com/https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v18.26.0.tar.gz"
  sha256 "584483d01ede68f6b0b3f1fcd2a86fe33080bf2eb2cbecb43a0c166e5294890d"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "72b09db1a9a8c4849d30600e03507da9b4fdf58b4628c43892e41b2c9c9597bb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "347d40629d788b165dd0d3e9645e6183d3c8eb597253c70d84efbb221ce7f590"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "652ffb8f238c5499f9d62da5594a4c718db7a9b6b5b42be1a140166601c3b9e3"
    sha256 cellar: :any_skip_relocation, sonoma:         "d6e4a78fb0f5c25ad343109e2f9ac644b29ac6dc370d8e13a77a8b32f24fe131"
    sha256 cellar: :any_skip_relocation, ventura:        "b7b64df45c93715ae00862d0fd480866a59a1779951ca8d12981dfc4e73447b5"
    sha256 cellar: :any_skip_relocation, monterey:       "765f50d05e2a3a0aa8c2ab0aed0aa2c914905992dceea896262df0a162a4c33b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "14b088a33d78505444dc705e0f539e429ed372b95c499f35de6108c96783a901"
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
