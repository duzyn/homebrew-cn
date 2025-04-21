class Fzf < Formula
  desc "Command-line fuzzy finder written in Go"
  homepage "https://github.com/junegunn/fzf"
  url "https://mirror.ghproxy.com/https://github.com/junegunn/fzf/archive/refs/tags/v0.61.2.tar.gz"
  sha256 "15a2d8b9bcd9cf85219f02f3cf750c45acd3d5901ce69a7dcdb9db3e12f36a90"
  license "MIT"
  head "https://github.com/junegunn/fzf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0b1c77e2133c59eb830c17c485ecde46e92295f409f5aad484832b0cecb35f6a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0b1c77e2133c59eb830c17c485ecde46e92295f409f5aad484832b0cecb35f6a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0b1c77e2133c59eb830c17c485ecde46e92295f409f5aad484832b0cecb35f6a"
    sha256 cellar: :any_skip_relocation, sonoma:        "70daa82000b38947dac40aa30ff99e1f5b282c37c1caae1ce282caab1def2611"
    sha256 cellar: :any_skip_relocation, ventura:       "70daa82000b38947dac40aa30ff99e1f5b282c37c1caae1ce282caab1def2611"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "32a8cf44f558e7a1b9ec8f861400540df6b44470c16fca911d71de092fc6ee9d"
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
