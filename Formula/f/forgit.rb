class Forgit < Formula
  desc "Interactive git commands in the terminal"
  homepage "https://github.com/wfxr/forgit"
  url "https://mirror.ghproxy.com/https://github.com/wfxr/forgit/releases/download/24.09.0/forgit-24.09.0.tar.gz"
  sha256 "9e16b88d6fdfaeec27c012e43864e6c870bfc53805f2f7e5ec4615ccd4519401"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "985a39302eab3128b6caacca2d985b39d946f3aaddf576d96daf3a35584a55c2"
  end

  depends_on "fzf"

  def install
    bin.install "bin/git-forgit"
    bash_completion.install "completions/git-forgit.bash" => "git-forgit"
    zsh_completion.install "completions/_git-forgit" => "_git-forgit"
    fish_completion.install "completions/git-forgit.fish"
    inreplace "forgit.plugin.zsh", 'FORGIT="$FORGIT_INSTALL_DIR', "FORGIT=\"#{opt_prefix}"
    inreplace "conf.d/forgit.plugin.fish",
              'set -x FORGIT "$FORGIT_INSTALL_DIR/bin/git-forgit"',
              "set -x FORGIT \"#{opt_prefix}/bin/git-forgit\""
    pkgshare.install "conf.d/forgit.plugin.fish"
    pkgshare.install "forgit.plugin.zsh"
    pkgshare.install_symlink "forgit.plugin.zsh" => "forgit.plugin.sh"
  end

  def caveats
    <<~EOS
      A shell plugin has been installed to:
        #{opt_pkgshare}/forgit.plugin.zsh
        #{opt_pkgshare}/forgit.plugin.sh
        #{opt_pkgshare}/forgit.plugin.fish
    EOS
  end

  test do
    system "git", "init"
    (testpath/"foo").write "bar"
    system "git", "forgit", "add", "foo"
  end
end
