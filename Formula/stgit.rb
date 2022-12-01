class Stgit < Formula
  include Language::Python::Shebang

  desc "Manage Git commits as a stack of patches"
  homepage "https://stacked-git.github.io"
  url "https://ghproxy.com/github.com/stacked-git/stgit/releases/download/v2.0.4/stgit-2.0.4.tar.gz"
  sha256 "fd80651a68a067b53aad96a9761cda480a98b7fc29605f2c46936aedcc605a16"
  license "GPL-2.0-only"
  head "https://github.com/stacked-git/stgit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5f2c93d5b4fed03f04a735a57ebc97a317591b64bdcf68678e31400f0e2f4a51"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d9f9771314be86152eca24a6f333e8fba0cbb8a073b49857676be15d22122cc9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "112ba18284f17c7b3d6350657dcee069376c9a4fd3f6818a6d2eefb6fbf9e929"
    sha256 cellar: :any_skip_relocation, ventura:        "c4ddf0ca5a4657db210c730b796655c2eadb525410a6af7ccbd460202e0ae810"
    sha256 cellar: :any_skip_relocation, monterey:       "886fe2ea50bd03a5c6768143cd73911b0503b5ed0d1b123b75d81182866a1203"
    sha256 cellar: :any_skip_relocation, big_sur:        "fb532f3e1923991b8bff2a6b3fe639ef902cdc52246e9756adf4fb9b002b2ccf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "71bff02f178a43099c31cb300e92cd4b50eaaff955cb002b0a78c99420ac7b92"
  end

  depends_on "rust" => :build
  depends_on "git"

  uses_from_macos "curl"
  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"stg", "completion")

    system "make", "-C", "contrib", "prefix=#{prefix}", "all"
  end

  test do
    system "git", "init"
    system "git", "config", "user.name", "BrewTestBot"
    system "git", "config", "user.email", "brew@test.bot"
    (testpath/"test").write "test"
    system "git", "add", "test"
    system "git", "commit", "--message", "Initial commit", "test"
    system "#{bin}/stg", "--version"
    system "#{bin}/stg", "init"
    system "#{bin}/stg", "new", "-m", "patch0"
    (testpath/"test").append_lines "a change"
    system "#{bin}/stg", "refresh"
    system "#{bin}/stg", "log"
  end
end
