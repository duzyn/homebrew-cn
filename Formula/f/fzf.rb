class Fzf < Formula
  desc "Command-line fuzzy finder written in Go"
  homepage "https://github.com/junegunn/fzf"
  url "https://mirror.ghproxy.com/https://github.com/junegunn/fzf/archive/refs/tags/0.52.1.tar.gz"
  sha256 "96848746ca78249c1fdd16f170776ce2f667097b60e4ffbd5ecdbd7dfac72ef9"
  license "MIT"
  head "https://github.com/junegunn/fzf.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f148bba640d6ed97b25a1894178e1872b4c18d1c0753400e3eed4cc4aefb8807"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ac4a88bd3c2eaf24a898a180b2c5eb3e77fcddb2bcdc8079d3ffa809158cb0cc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "79a71f2bbde75e9a4a682e7c6404e318881ce968fb39564fe6b0b6080de4e886"
    sha256 cellar: :any_skip_relocation, sonoma:         "f8d1475d30cb2c6b7dede872b54b64e9eb26a3924445b0dd14627f2baa2acbcc"
    sha256 cellar: :any_skip_relocation, ventura:        "86311fab3d7500dfc8268f880296c572adfd6d52e458d6b2ed01e8c03ca71de1"
    sha256 cellar: :any_skip_relocation, monterey:       "8a9144b076080c753100101d3c02b0607de89489c831d4b77bd0e6ed0c8060f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4a81a17c69d8bd88d6fcb493a8bfecafddc8e3ee9ab96bedda24a1795892a17a"
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
