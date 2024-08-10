class GitMachete < Formula
  include Language::Python::Virtualenv

  desc "Git repository organizer & rebase workflow automation tool"
  homepage "https://github.com/VirtusLab/git-machete"
  url "https://files.pythonhosted.org/packages/0c/6d/abbcac965ffb697305b47f560539c8c63db2bd30eccf0c136b627491afb2/git_machete-3.27.0.tar.gz"
  sha256 "e456dc2f3539e4bb3cd1392996761fc9a6ff8de8841695f91c1d4c7d4adbeb21"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "630e286b2ce6005ce434ce758ab4ddb38b22ef3e93215c6996396b6d9abf1a29"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "630e286b2ce6005ce434ce758ab4ddb38b22ef3e93215c6996396b6d9abf1a29"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "630e286b2ce6005ce434ce758ab4ddb38b22ef3e93215c6996396b6d9abf1a29"
    sha256 cellar: :any_skip_relocation, sonoma:         "630e286b2ce6005ce434ce758ab4ddb38b22ef3e93215c6996396b6d9abf1a29"
    sha256 cellar: :any_skip_relocation, ventura:        "630e286b2ce6005ce434ce758ab4ddb38b22ef3e93215c6996396b6d9abf1a29"
    sha256 cellar: :any_skip_relocation, monterey:       "630e286b2ce6005ce434ce758ab4ddb38b22ef3e93215c6996396b6d9abf1a29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "31f7f9126696af96944812df421b96b63045f3f63e67687490d607e0c535c813"
  end

  depends_on "python@3.12"

  def install
    virtualenv_install_with_resources

    man1.install "docs/man/git-machete.1"

    bash_completion.install "completion/git-machete.completion.bash"
    zsh_completion.install "completion/git-machete.completion.zsh"
    fish_completion.install "completion/git-machete.fish"
  end

  test do
    system "git", "init"
    system "git", "config", "user.email", "you@example.com"
    system "git", "config", "user.name", "Your Name"
    (testpath/"test").write "foo"
    system "git", "add", "test"
    system "git", "commit", "--message", "Initial commit"
    system "git", "branch", "-m", "main"
    system "git", "checkout", "-b", "develop"
    (testpath/"test2").write "bar"
    system "git", "add", "test2"
    system "git", "commit", "--message", "Other commit"

    (testpath/".git/machete").write "main\n  develop"
    expected_output = "  main\n  |\n  | Other commit\n  o-develop *\n"
    assert_equal expected_output, shell_output("git machete status --list-commits")
  end
end
