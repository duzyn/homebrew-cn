class Fzf < Formula
  desc "Command-line fuzzy finder written in Go"
  homepage "https://github.com/junegunn/fzf"
  url "https://mirror.ghproxy.com/https://github.com/junegunn/fzf/archive/refs/tags/v0.60.2.tar.gz"
  sha256 "0df4bcba5519762ec2a51296d9b44f15543ec1f67946b027e0339a02b19a055c"
  license "MIT"
  head "https://github.com/junegunn/fzf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "659ef1f6197f2f1f584f524218e90f4bdecd7f8b38d67a3425e992f180ea8a47"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "659ef1f6197f2f1f584f524218e90f4bdecd7f8b38d67a3425e992f180ea8a47"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "659ef1f6197f2f1f584f524218e90f4bdecd7f8b38d67a3425e992f180ea8a47"
    sha256 cellar: :any_skip_relocation, sonoma:        "645f3c9fe30aad8beeb660148fe38d59a3f365d57cce4871af4132b23f48623a"
    sha256 cellar: :any_skip_relocation, ventura:       "645f3c9fe30aad8beeb660148fe38d59a3f365d57cce4871af4132b23f48623a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d3b618b50e87754841ab73c65bde6c804ecd6c0daa9f9582418edfc24ed083ee"
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
