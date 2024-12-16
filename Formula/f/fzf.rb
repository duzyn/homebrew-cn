class Fzf < Formula
  desc "Command-line fuzzy finder written in Go"
  homepage "https://github.com/junegunn/fzf"
  url "https://mirror.ghproxy.com/https://github.com/junegunn/fzf/archive/refs/tags/v0.57.0.tar.gz"
  sha256 "d4e8e25fad2d3f75943b403c40b61326db74b705bf629c279978fdd0ceb1f97c"
  license "MIT"
  head "https://github.com/junegunn/fzf.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f4936470e8ddcd195e4345557c51fd86015e81fd52b9ee3eefef66d37b16e10d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f4936470e8ddcd195e4345557c51fd86015e81fd52b9ee3eefef66d37b16e10d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f4936470e8ddcd195e4345557c51fd86015e81fd52b9ee3eefef66d37b16e10d"
    sha256 cellar: :any_skip_relocation, sonoma:        "afc798baf3dd3230d0fe570dcc682db1e11ec8a4f7e4012d8d49d46afbcaaf50"
    sha256 cellar: :any_skip_relocation, ventura:       "afc798baf3dd3230d0fe570dcc682db1e11ec8a4f7e4012d8d49d46afbcaaf50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "278da1e0a4a8321b9b7a331e12717965741d8df9b2b0403118604a7635e93abe"
  end

  depends_on "go" => :build

  uses_from_macos "ncurses"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version} -X main.revision=brew")
    man1.install "man/man1/fzf.1", "man/man1/fzf-tmux.1"
    bin.install "bin/fzf-tmux"
    bin.install "bin/fzf-preview.sh"

    # Please don't install these into standard locations (e.g. `zsh_completion`, etc.)
    # See: https://github.com/Homebrew/homebrew-core/pull/137432
    #      https://github.com/Homebrew/legacy-homebrew/pull/27348
    #      https://github.com/Homebrew/homebrew-core/pull/70543
    prefix.install "install", "uninstall"
    (prefix/"shell").install %w[bash zsh fish].map { |s| "shell/key-bindings.#{s}" }
    (prefix/"shell").install %w[bash zsh].map { |s| "shell/completion.#{s}" }
    (prefix/"plugin").install "plugin/fzf.vim"
  end

  def caveats
    <<~EOS
      To set up shell integration, see:
        https://github.com/junegunn/fzf#setting-up-shell-integration
      To use fzf in Vim, add the following line to your .vimrc:
        set rtp+=#{opt_prefix}
    EOS
  end

  test do
    (testpath/"list").write %w[hello world].join($INPUT_RECORD_SEPARATOR)
    assert_equal "world", pipe_output("#{bin}/fzf -f wld", (testpath/"list").read).chomp
  end
end
