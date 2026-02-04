class Kingfisher < Formula
  desc "MongoDB's blazingly fast secret scanning and validation tool"
  homepage "https://github.com/mongodb/kingfisher"
  url "https://mirror.ghproxy.com/https://github.com/mongodb/kingfisher/archive/refs/tags/v1.77.0.tar.gz"
  sha256 "cc91d1ec21de578ba7729fe15c0a6b2a019fe0e352d836e95690e45db434b724"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d3f22079a6aee3dac3783acc9daf2ce66612c09f3d43de8c2554ea9999c4c7b0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8b1380cd2a9f56d9825448e5e214f9fcab0be874ff9f1b52fde251abff027bae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c738207e93446e29616de118de7a7123a433eb4ea68601016a2f655b304ee1c4"
    sha256 cellar: :any_skip_relocation, sonoma:        "9220c50d261c545dbfa0a6b4b78133e793d4490dc37c05beac82b454b67f2f67"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "759bd96b2e9d7f9cd1fcd34a5ea64b22f598e61cf5ae1c385bef796bd45c3484"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6c377d135cfc173ffc1e742cafbfcb63e5c2419b734527b34f372afe92344220"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  def install
    system "cargo", "install", "--features", "system-alloc", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/kingfisher scan --git-url https://github.com/homebrew/.github")
    assert_match "|Findings....................: 0", output
  end
end
