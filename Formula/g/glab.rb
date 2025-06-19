class Glab < Formula
  desc "Open-source GitLab command-line tool"
  homepage "https://gitlab.com/gitlab-org/cli"
  url "https://gitlab.com/gitlab-org/cli.git",
    tag:      "v1.60.1",
    revision: "4f0ea8d59d11489757b986b327441e3c4c91e6a0"
  license "MIT"
  head "https://gitlab.com/gitlab-org/cli.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "11aed2cc9f5d9a41a6e44b656c02a8375cc23ae8c1d1919664396b4b42f91b29"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "11aed2cc9f5d9a41a6e44b656c02a8375cc23ae8c1d1919664396b4b42f91b29"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "11aed2cc9f5d9a41a6e44b656c02a8375cc23ae8c1d1919664396b4b42f91b29"
    sha256 cellar: :any_skip_relocation, sonoma:        "0828d326f3ac94daa760eaaa2b89bc954da27698d8062dab5c49b244cf4b64fa"
    sha256 cellar: :any_skip_relocation, ventura:       "0828d326f3ac94daa760eaaa2b89bc954da27698d8062dab5c49b244cf4b64fa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "78ce9db644666894ec6779afb91018f995d8ffbf8fc1644de4b6cc6450123193"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "361218cc4a461775b0c4eccdb3f9fe344731744deaf74a4b706758344f871ed0"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.mac?
    system "make"
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
