class Fasd < Formula
  desc "CLI tool for quick access to files and directories"
  homepage "https://github.com/clvv/fasd"
  url "https://mirror.ghproxy.com/https://github.com/clvv/fasd/archive/refs/tags/1.0.1.tar.gz"
  sha256 "88efdfbbed8df408699a14fa6c567450bf86480f5ff3dde42d0b3e1dee731f65"
  license "MIT"
  head "https://github.com/clvv/fasd.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9241df0f32971ce5a84c977f6908b93114946843813d5375ba7b983a7a783188"
  end

  disable! date: "2023-06-19", because: :repo_archived

  def install
    bin.install "fasd"
    man1.install "fasd.1"
  end

  test do
    system "#{bin}/fasd", "--init", "auto"
  end
end
