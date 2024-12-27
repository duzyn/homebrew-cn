class Sk < Formula
  desc "Fuzzy Finder in rust!"
  homepage "https://github.com/lotabout/skim"
  url "https://mirror.ghproxy.com/https://github.com/lotabout/skim/archive/refs/tags/v0.15.6.tar.gz"
  sha256 "2c69026336a8e4c58e0f49ebba497a93af3e70a2208240003e2ddb96c3fb674e"
  license "MIT"
  head "https://github.com/lotabout/skim.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "feae12a3dbd6402e3734dec98ced3c749fb5b11d4323be4ae3ffb1254b840fe0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7247418d30cd703ac75ba9b0b20ce299e9e21d4c3215610dc817a66cbfcf4bd5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "79be7ae3cc886a38b75d9e07a93151c9f6a7a60f937daf8a9731b5b51bc0f9c0"
    sha256 cellar: :any_skip_relocation, sonoma:        "038da0d1ed1b25b958e5fe19dd485930f38484eb9dac197ae3693b41c597f5f7"
    sha256 cellar: :any_skip_relocation, ventura:       "fb2a4851e2f2948e3af1e358f7db79b0d3f5734acd0a670f8de804d869949a91"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e6e60942b833adf903ae2bd9b5bc21115f2a7103e056e1711b9e943730bb1b44"
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
