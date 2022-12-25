class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v12.29.0.tar.gz"
  sha256 "de8c5a3a057facb3f8f2e03ce78acf5505066d7807ded5bde006de117238c534"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "72444ae8bff43295395115a34291c0743dd204ebf75435d34e1b2734f3b1f55b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c52282bcda7b57e576ee8e6c48b9dbcb968a52c1952e03f08a256385c95151ef"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0642acee560c54054a082b3497cfd247fa9d5f71d13eb7dd0a47d77748f1c073"
    sha256 cellar: :any_skip_relocation, ventura:        "d77ade9a4843a72ebb0515b7f5eb5b1f1160a3ed83512a24b9ac704e08dcb39c"
    sha256 cellar: :any_skip_relocation, monterey:       "ee3ecff7eff61b6b9b1ae288273791aa2f3bc1e3da0c7747fb4f9ea34f5eaac6"
    sha256 cellar: :any_skip_relocation, big_sur:        "fa4f86bb2b3604327e9beeaf8a580dc53ebe0ece670fa0ef16686ccf47e00d93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e80f1284cf2c405cbc8681c437842fb232d392b322feab1b2a4a8ab882199ca4"
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
