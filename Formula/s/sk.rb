class Sk < Formula
  desc "Fuzzy Finder in rust!"
  homepage "https://github.com/lotabout/skim"
  url "https://mirror.ghproxy.com/https://github.com/lotabout/skim/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "f999c73e19e1f53e993b93dc85fc8cd19608a5d3939bb847f19f32d71980a2de"
  license "MIT"
  head "https://github.com/lotabout/skim.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "48b791932bb4f39fb345f656047db66cc38b6ea6343305cb005adced21da2ef7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9d899b18b12bd4a36212f1bfa357bb9da5ded66a794f6d61620390bffa408381"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e4f862fe0e1af24f53587bab4a1a2a8bd443a475449128af54f4e1faf1e37f56"
    sha256 cellar: :any_skip_relocation, sonoma:        "66db12d74bcfed37f3f8f3a623c3644b70dd0af70472f65d1411ce78a2182f3e"
    sha256 cellar: :any_skip_relocation, ventura:       "bf5cb9c6594e5b664b571e0a02bdb12d746ca061fb829c5fdc3b2dbd426c41c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "150cbb2acd0b16b865c4bc44a9851b9a834a039880611ee17cc91cf1f26ba2ee"
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
