class Fzf < Formula
  desc "Command-line fuzzy finder written in Go"
  homepage "https://github.com/junegunn/fzf"
  url "https://mirror.ghproxy.com/https://github.com/junegunn/fzf/archive/refs/tags/v0.54.2.tar.gz"
  sha256 "2f4f7bbe2bfbe1eb24ab86fc2a5d93a1f55c33aaca9fe39495af0128712ca81f"
  license "MIT"
  head "https://github.com/junegunn/fzf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "df219398ecb1bf6b738e89281c8ea26e3ae35a7ed637fb71f570ea0e7464e025"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ce690946fa3677891414cc493900bedda2dbe6b4edfc583e43d7816ecdf54135"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "33b7f86c0d6b2344909ce14d6baaa7189e1e0a3c8b4b1c558b35bf70f4ae4435"
    sha256 cellar: :any_skip_relocation, sonoma:         "e4774114555f1f5bb2e1f155db407d959ef0ed6e0aa26b3a4373e2a0ac255b8f"
    sha256 cellar: :any_skip_relocation, ventura:        "c3e04967da8bf3d26d692d6996e195b57f863740895a60e6dce4e7abb1bb0e58"
    sha256 cellar: :any_skip_relocation, monterey:       "a13a619f5b50c0f501e8aec8f1f2cbcf535c7e12433ad9cbf5ad71bbcb3e4656"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ddf09dfeaacf4b38f66a85a31a99e55a7b837e88a627c6dc0bcc23eb89b97e94"
  end

  depends_on "go" => :build

  uses_from_macos "ncurses"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version} -X main.revision=brew")
    man1.install "man/man1/fzf.1", "man/man1/fzf-tmux.1"
    bin.install "bin/fzf-tmux"

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
      To set up shell integration, add this to your shell configuration file:
        # bash
        eval "$(fzf --bash)"

        # zsh
        source <(fzf --zsh)

        # fish
        fzf --fish | source

      To use fzf in Vim, add the following line to your .vimrc:
        set rtp+=#{opt_prefix}
    EOS
  end

  test do
    (testpath/"list").write %w[hello world].join($INPUT_RECORD_SEPARATOR)
    assert_equal "world", pipe_output("#{bin}/fzf -f wld", (testpath/"list").read).chomp
  end
end
