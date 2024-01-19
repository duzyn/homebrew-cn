class Zinit < Formula
  desc "Flexible and fast Zsh plugin manager"
  homepage "https://zdharma-continuum.github.io/zinit/wiki/"
  url "https://mirror.ghproxy.com/https://github.com/zdharma-continuum/zinit/archive/refs/tags/v3.13.0.tar.gz"
  sha256 "3180db2379cffcabdecaeac7b504e662ace87655449d752d14d748e431b0d1bc"
  license "MIT"
  head "https://github.com/zdharma-continuum/zinit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4897f8cd80c8724603a0c6f1b85110fbf581fdbfee07c7d0db2c55872878772e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4897f8cd80c8724603a0c6f1b85110fbf581fdbfee07c7d0db2c55872878772e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4897f8cd80c8724603a0c6f1b85110fbf581fdbfee07c7d0db2c55872878772e"
    sha256 cellar: :any_skip_relocation, sonoma:         "158b24497c21a5ce9d1c7a21ebc623269b68162821a3b41636a49e4aeba3ddf1"
    sha256 cellar: :any_skip_relocation, ventura:        "158b24497c21a5ce9d1c7a21ebc623269b68162821a3b41636a49e4aeba3ddf1"
    sha256 cellar: :any_skip_relocation, monterey:       "158b24497c21a5ce9d1c7a21ebc623269b68162821a3b41636a49e4aeba3ddf1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4897f8cd80c8724603a0c6f1b85110fbf581fdbfee07c7d0db2c55872878772e"
  end

  uses_from_macos "zsh"

  def install
    prefix.install Dir["*"]
    man1.install_symlink prefix/"doc/zinit.1"
  end

  def caveats
    <<~EOS
      To activate zinit, add the following to your ~/.zshrc:
        source #{opt_prefix}/zinit.zsh
    EOS
  end

  test do
    system "zsh", "-c", "source #{opt_prefix}/zinit.zsh && zinit load zsh-users/zsh-autosuggestions"
  end
end
