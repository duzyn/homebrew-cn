class Fzf < Formula
  desc "Command-line fuzzy finder written in Go"
  homepage "https://github.com/junegunn/fzf"
  url "https://mirror.ghproxy.com/https://github.com/junegunn/fzf/archive/refs/tags/v0.61.0.tar.gz"
  sha256 "5d72cdf708c6adc240b3b43dfecd218cf4703ea609422fb4d62812e9f79f0a12"
  license "MIT"
  head "https://github.com/junegunn/fzf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "18cd8adbcd003cde3aac476bf86a20acd17d5a8e0051a86150d76e6d6cddd66c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "18cd8adbcd003cde3aac476bf86a20acd17d5a8e0051a86150d76e6d6cddd66c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "18cd8adbcd003cde3aac476bf86a20acd17d5a8e0051a86150d76e6d6cddd66c"
    sha256 cellar: :any_skip_relocation, sonoma:        "8abadf1e9641303e7866858907808fff899e252a4682e6f41475fc5ef35ced70"
    sha256 cellar: :any_skip_relocation, ventura:       "8abadf1e9641303e7866858907808fff899e252a4682e6f41475fc5ef35ced70"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4e26dd087b1a3d88f3eb95abd0965ff20535718ba9a39eca0ef359705d7bfbd5"
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
