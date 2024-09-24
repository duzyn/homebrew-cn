class Kerl < Formula
  desc "Easy building and installing of Erlang/OTP instances"
  homepage "https://github.com/kerl/kerl"
  url "https://mirror.ghproxy.com/https://github.com/kerl/kerl/archive/refs/tags/4.3.0.tar.gz"
  sha256 "3270070f4a61a080508810a9fea2a3173439cc5dcaf12ea69ca8baf0d68aadd9"
  license "MIT"
  head "https://github.com/kerl/kerl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a0bb9b435fdad340f08bc6dd37877aa75041019eccf6b145b4a558c444e6b855"
  end

  def install
    bin.install "kerl"

    bash_completion.install "bash_completion/kerl"
    zsh_completion.install "zsh_completion/_kerl"
  end

  test do
    system bin/"kerl", "list", "releases"
  end
end
