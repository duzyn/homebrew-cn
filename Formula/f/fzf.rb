class Fzf < Formula
  desc "Command-line fuzzy finder written in Go"
  homepage "https://github.com/junegunn/fzf"
  url "https://mirror.ghproxy.com/https://github.com/junegunn/fzf/archive/refs/tags/v0.56.3.tar.gz"
  sha256 "fc7bf3fcfdc3c9562237d1e82196618201a39b3fd6bf3364149516b288f5a24a"
  license "MIT"
  head "https://github.com/junegunn/fzf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5950deebde5f28640f560d325d24a2de3733ceee67018ea871bd892c72c7cc02"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5950deebde5f28640f560d325d24a2de3733ceee67018ea871bd892c72c7cc02"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5950deebde5f28640f560d325d24a2de3733ceee67018ea871bd892c72c7cc02"
    sha256 cellar: :any_skip_relocation, sonoma:        "d966b27087cf6f532ebfc3b0d049e4ef04378bd2b3c2c8381016b37c762b9e1a"
    sha256 cellar: :any_skip_relocation, ventura:       "d966b27087cf6f532ebfc3b0d049e4ef04378bd2b3c2c8381016b37c762b9e1a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4634fa4ef2deba42f297111e2f6a3104963d83a7d24767ccf6d2b9ce74ed9d13"
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
