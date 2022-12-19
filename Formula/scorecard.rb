class Scorecard < Formula
  desc "Security health metrics for Open Source"
  homepage "https://github.com/ossf/scorecard"
  url "https://github.com/ossf/scorecard.git",
      tag:      "v4.10.1",
      revision: "6c5d964fcde4b83fa5ad5e40060e9e5ba920cd2f"
  license "Apache-2.0"
  head "https://github.com/ossf/scorecard.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7542fb27ea61c5ead5a53a5e1a565b2ecf9ebdfd0607d960c90500c61554391e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6fc793a38002d20eb9044421c348cc776b000ba23eb7c98ae85d6735835778d1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1e338a7ded98d7bc293e37280ddcc7297f188c62c916a6da79307daf4d734396"
    sha256 cellar: :any_skip_relocation, ventura:        "ac0b36749b0ac9b9998607255ff2ded842e53734b8a135f6a9c16bcea2d0a1d4"
    sha256 cellar: :any_skip_relocation, monterey:       "23c9a8613ad2b19c915ac366577aba451f5f6a02c0cd7d12b59abd1f043b4090"
    sha256 cellar: :any_skip_relocation, big_sur:        "69e865f678c6cd90ff374a455b2576be3a60751b231b31111054e3679582d252"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0b31f3f12957490231137b8bff69b35fe0a2fc89ca7d6fa9e3722e6e7ffebe20"
  end

  depends_on "go" => :build

  def install
    pkg = "sigs.k8s.io/release-utils/version"
    ldflags = %W[
      -s -w
      -X #{pkg}.gitVersion=#{version}
      -X #{pkg}.gitCommit=#{Utils.git_head}
      -X #{pkg}.gitTreeState=clean
      -X #{pkg}.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
    system "make", "generate-docs"
    doc.install "docs/checks.md"

    generate_completions_from_executable(bin/"scorecard", "completion")
  end

  test do
    ENV["GITHUB_AUTH_TOKEN"] = "test"
    output = shell_output("#{bin}/scorecard --repo=github.com/kubernetes/kubernetes --checks=Maintained 2>&1", 1)
    expected_output = "InitRepo: repo unreachable: GET https://api.github.com/repos/google/oss-fuzz: 401"
    assert_match expected_output, output

    assert_match version.to_s, shell_output("#{bin}/scorecard version 2>&1")
  end
end
