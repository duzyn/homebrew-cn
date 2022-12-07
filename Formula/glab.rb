class Glab < Formula
  desc "Open-source GitLab command-line tool"
  homepage "https://gitlab.com/gitlab-org/cli"
  url "https://gitlab.com/gitlab-org/cli/-/archive/v1.24.0/cli-v1.24.0.tar.gz"
  sha256 "a064a95874162b880d92cdd9bc83c7b113b11e2bf0b6bd67a2bc5b96039e815d"
  license "MIT"
  head "https://gitlab.com/gitlab-org/cli.git", branch: "trunk"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6fd6fadca0a306269543634f43cd70f7691ca741985841b2926305fd78d3c2ea"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f8259a0e4b1e36ec606a6326fa915622b810b91e912f1715b25312906288a207"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1150ed2c050fd25bf186fd0a4282dd5792b37bc61ba68b37d54f1157232d89c6"
    sha256 cellar: :any_skip_relocation, ventura:        "ee3cd8cedea630b09a0573e6fca5c158a656ffbcf15d3b076e5c3832be220612"
    sha256 cellar: :any_skip_relocation, monterey:       "3b2c3fe3c59c0b67bb3a40140608aa18ea6af5c9cb22287fedd1566bab14f6fe"
    sha256 cellar: :any_skip_relocation, big_sur:        "5bec4f2f341c4482bfb6544a541e1d5a45340b4922b50d4d9e23fcb880a17a48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a421e1ebbf14b6c9c297d8b4509cc786d93508b32d2e8bbb1c91abe3c8a3148e"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.mac?

    system "make", "GLAB_VERSION=#{version}"
    bin.install "bin/glab"
    generate_completions_from_executable(bin/"glab", "completion", "--shell")
  end

  test do
    system "git", "clone", "https://gitlab.com/cli-automated-testing/homebrew-testing.git"
    cd "homebrew-testing" do
      assert_match "Matt Nohr", shell_output("#{bin}/glab repo contributors")
      assert_match "This is a test issue", shell_output("#{bin}/glab issue list --all")
    end
  end
end
