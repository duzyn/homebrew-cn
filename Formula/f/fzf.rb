class Fzf < Formula
  desc "Command-line fuzzy finder written in Go"
  homepage "https://github.com/junegunn/fzf"
  url "https://mirror.ghproxy.com/https://github.com/junegunn/fzf/archive/refs/tags/v0.60.1.tar.gz"
  sha256 "9252219096cf9a9dbf41fc177b9007ecafcfab4ff61ece8d78fee99cb9997bcc"
  license "MIT"
  head "https://github.com/junegunn/fzf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "620066c45a518f97f816e533b295fbcd23f77b3a13ae863629e4915d5e442e65"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "620066c45a518f97f816e533b295fbcd23f77b3a13ae863629e4915d5e442e65"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "620066c45a518f97f816e533b295fbcd23f77b3a13ae863629e4915d5e442e65"
    sha256 cellar: :any_skip_relocation, sonoma:        "68341e0108c2af9eb00202bd3a5e36038d3ba80810640cf40cae585a3ed9a55f"
    sha256 cellar: :any_skip_relocation, ventura:       "68341e0108c2af9eb00202bd3a5e36038d3ba80810640cf40cae585a3ed9a55f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eb01fb8033ef9b6d4d76babbdf43ddb8f344974d50908805f30ed105a4659791"
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
