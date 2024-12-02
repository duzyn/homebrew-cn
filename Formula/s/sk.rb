class Sk < Formula
  desc "Fuzzy Finder in rust!"
  homepage "https://github.com/lotabout/skim"
  url "https://mirror.ghproxy.com/https://github.com/lotabout/skim/archive/refs/tags/v0.15.4.tar.gz"
  sha256 "2e6f4638b1fd7a0bb14fb53945b7cbae050597535fda253de912534b1475aa8d"
  license "MIT"
  head "https://github.com/lotabout/skim.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "07d328b42233d8152edbbe925574fda4b99208fae936b0939339fc3cd3f47e11"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "392bac4648bd14593527db79d5fbe8ea369cc359a3e008081881f378003d7bb0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "75d5e9bdef31bac6251fd3d718d0273deb8643252332a28e4468c6074bd29195"
    sha256 cellar: :any_skip_relocation, sonoma:        "58c76b8d9f1b86ec2259e0a7f492865c49adf06684d2cebc7b54e3192e21d6ae"
    sha256 cellar: :any_skip_relocation, ventura:       "d4c19d3bb6c6a7e53bd253a65f9905eada2ecaaebcb35452f351089887603266"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7c81fdbe60d0f5cd0781b8d09379e3053cd769ab20774d5c31e0dc548fe5890b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "skim")

    pkgshare.install "install"
    bash_completion.install "shell/key-bindings.bash"
    bash_completion.install "shell/completion.bash"
    fish_completion.install "shell/key-bindings.fish" => "skim.fish"
    zsh_completion.install "shell/key-bindings.zsh"
    zsh_completion.install "shell/completion.zsh"
    man1.install "man/man1/sk.1", "man/man1/sk-tmux.1"
    bin.install "bin/sk-tmux"
  end

  test do
    assert_match(/.*world/, pipe_output("#{bin}/sk -f wld", "hello\nworld"))
  end
end
