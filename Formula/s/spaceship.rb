class Spaceship < Formula
  desc "Zsh prompt for Astronauts"
  homepage "https://spaceship-prompt.sh/"
  url "https://mirror.ghproxy.com/https://github.com/spaceship-prompt/spaceship-prompt/archive/refs/tags/v4.19.3.tar.gz"
  sha256 "9112510c98eeaffd40f8b8ddff44fa786ce00f81549f135785eb1735d9266609"
  license "MIT"
  head "https://github.com/spaceship-prompt/spaceship-prompt.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8fa53de2f7fb6a07df0abf17916077307eeeefa9ad3bae293af08904be44fb82"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "803ad24c2ad5d0c38c69fd2ed273dde793419f56c915507e19215ea9b63a6d5a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "df297250f311f51220188f32ee2276ed91637d9051ef1192c82f905e6aaf68ff"
    sha256 cellar: :any_skip_relocation, sonoma:        "af5f00c6527908dcd5dff6f043f070968fcee742589dbbda4f20c2d7d8cf9a1f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0bc4da97d00e75994a85eda0fb4d6135898320478b13be1e3a7f23ab54654fb0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bfc8a5396c9ba018a0a9200e75a94c46b784d8b7192c6333c40aba91fea95d7b"
  end

  depends_on "zsh-async"
  uses_from_macos "zsh" => :test

  def install
    system "make", "compile"
    prefix.install Dir["*"]
  end

  def caveats
    <<~EOS
      To activate Spaceship, add the following line to ~/.zshrc:
        source "#{opt_prefix}/spaceship.zsh"
      If your .zshrc sets ZSH_THEME, remove that line.
    EOS
  end

  test do
    assert_match "SUCCESS",
      shell_output("zsh -fic '. #{opt_prefix}/spaceship.zsh && (( ${+SPACESHIP_VERSION} )) && echo SUCCESS'")
  end
end
