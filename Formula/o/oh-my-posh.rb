class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://mirror.ghproxy.com/https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v19.1.0.tar.gz"
  sha256 "d2599da67fe8c360696d3abfa107832a3e42ca904953aaf22bb95806587e490d"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8f33915009c0b685ee281e746de73e94a5e74cf05a7bfae2a077952855475d2b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "65afe8ed2f2dd487dae20ff2012e62440d5f2b956944ce9d75d3254874d297ce"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "04502107e7ca34f4c2aafb2b5f3046d6e0835819192f62e595319acaa7c391fb"
    sha256 cellar: :any_skip_relocation, sonoma:         "f45d962d799a989a6c82b1bf63c073156a5518cb6c2d97cca422902650220e56"
    sha256 cellar: :any_skip_relocation, ventura:        "f0e971d155cf604676e26a80891994f7cbfb75e0003dccd63ae7f58d279b3551"
    sha256 cellar: :any_skip_relocation, monterey:       "330195bcf58a0934e57e63392f87eda8bfbaef9a37ac88c6e96f74b8b22753ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "86471cf22fd4285b22b40ade9fe0b6858e8779a55d23c470f433f8238c0be1c4"
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
