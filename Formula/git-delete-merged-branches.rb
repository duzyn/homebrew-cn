class GitDeleteMergedBranches < Formula
  include Language::Python::Virtualenv

  desc "Command-line tool to delete merged Git branches"
  homepage "https://github.com/hartwork/git-delete-merged-branches"
  url "https://files.pythonhosted.org/packages/7c/59/5bb78097446bba8e46c9931f543a256aba395c5d9fde92510d5274f535c8/git-delete-merged-branches-7.3.1.tar.gz"
  sha256 "7b2231cb67fd08e2a05999ef00e6a7cf3ce7fa22f82869d21517af3f0f333644"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a6a3126dc848b191d5dda481737d61c7364358f5384d49c3925674e0c08d26dd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b90139bf4996d5b7a9a55f9c86ddc5d9865c11cc68c06bb28104860291ca91a2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "79d5ee880014b7a52d82c29d2f8ad4acdc1d9cb33597ed9817b99d44a53d162e"
    sha256 cellar: :any_skip_relocation, ventura:        "300009a14c0aa66c047501edca00d9eb3d8409cfba72b4e4398d538e922347ab"
    sha256 cellar: :any_skip_relocation, monterey:       "cfa198a4ed613572e3d80e5e285b3836c37023366855655571df7beacfec6e35"
    sha256 cellar: :any_skip_relocation, big_sur:        "d69ccf4b987368a6e56959bea9910b39848e640b9024da8f9cf20136319fd3ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cdaa1f519063acc4c1206d7f699fe9e71159b9303456270ea1f06d5ec575fd32"
  end

  depends_on "python@3.11"

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/fb/93/180be2342f89f16543ec4eb3f25083b5b84eba5378f68efff05409fb39a9/prompt_toolkit-3.0.36.tar.gz"
    sha256 "3e163f254bef5a03b146397d7c1963bd3e2812f0964bb9a24e6ec761fd28db63"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/89/38/459b727c381504f361832b9e5ace19966de1a235d73cdbdea91c771a1155/wcwidth-0.2.5.tar.gz"
    sha256 "c4d647b99872929fdb7bdcaa4fbe7f01413ed3d98077df798530e5b04f116c83"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    origin = testpath/"origin"
    origin.mkdir
    clone = testpath/"clone"

    cd origin do
      system "git", "config", "--global", "init.defaultBranch", "master"
      system "git", "init"
      system "git", "config", "user.name", "BrewTestBot"
      system "git", "config", "user.email", "BrewTestBot@example.com"
      system "git", "commit", "--allow-empty", "-m", "Initial commit"
    end

    system "git", "clone", origin, clone

    cd clone do
      system "git", "config", "remote.origin.dmb-enabled", "true"
      system "git", "config", "branch.master.dmb-required", "true"
      system "git", "config", "delete-merged-branches.configured", "5.0.0+"
      system "git", "checkout", "-b", "new-branch"
      system "git", "checkout", "-"
      system "git", "delete-merged-branches", "--yes"
      branches = shell_output("git branch").split("\n")
      assert_equal 1, branches.length
    end
  end
end
