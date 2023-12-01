class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://mirror.ghproxy.com/https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v18.27.1.tar.gz"
  sha256 "6c5ed068c26d48211708a8b6f37c680a8bc7bb2b6bcf8afa6ccc153d83894017"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dbc3d7be6e6223a633b06b6e69caf563b21dfd4514c40d0abf566f388a3acd36"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d220a968825d07c3915321565029c0e636b3c5a87bfb594702186de43ab8549d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7a4153442e6d3eb923f9a067a3f57d6ff9bfaf590cdf5246b96f69076cf8805f"
    sha256 cellar: :any_skip_relocation, sonoma:         "8aa24a3aacc7989c657e844953c42d3c039d00714dbfc83a59796cfa4dd6acfc"
    sha256 cellar: :any_skip_relocation, ventura:        "935472b37318638c8536933fad89f8a6cfb243bfb9770c145b3ee01bbf1ec78d"
    sha256 cellar: :any_skip_relocation, monterey:       "5821bf4a4e59516280f16345eed244d411cce45010c0a1d8f711e180c61c4c55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2d54cfe38bb321df7c7c0edbb6e21cdbcabba16c9ee04754ed7a5af903d3736b"
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
