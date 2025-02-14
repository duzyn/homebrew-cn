class Fzf < Formula
  desc "Command-line fuzzy finder written in Go"
  homepage "https://github.com/junegunn/fzf"
  url "https://mirror.ghproxy.com/https://github.com/junegunn/fzf/archive/refs/tags/v0.60.0.tar.gz"
  sha256 "69255fd9301e491b6ac6788bf1caf5d4f70d9209b4b8ab70ceb1caf6a69b5c16"
  license "MIT"
  head "https://github.com/junegunn/fzf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fe4d9d402b1de39bc6cff579e60a135feb334ce50ab112fa80a01de0e36a7bf7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fe4d9d402b1de39bc6cff579e60a135feb334ce50ab112fa80a01de0e36a7bf7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fe4d9d402b1de39bc6cff579e60a135feb334ce50ab112fa80a01de0e36a7bf7"
    sha256 cellar: :any_skip_relocation, sonoma:        "9dc07d8302fc1da725d28b38bb9cdf48f179625dd03d604c77155c9559c58ed3"
    sha256 cellar: :any_skip_relocation, ventura:       "9dc07d8302fc1da725d28b38bb9cdf48f179625dd03d604c77155c9559c58ed3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "25a86b33d2f452d95d8527391eb0c32fdfc3635021b477ff95f78584c266db38"
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
