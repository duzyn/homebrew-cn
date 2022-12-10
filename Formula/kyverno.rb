class Kyverno < Formula
  desc "Kubernetes Native Policy Management"
  homepage "https://kyverno.io/"
  url "https://github.com/kyverno/kyverno.git",
      tag:      "v1.8.4",
      revision: "0675d21dd9586a8e55ac2b3796a8db850b996895"
  license "Apache-2.0"
  head "https://github.com/kyverno/kyverno.git", branch: "main"

  # This regex is intended to match Kyverno version tags (e.g., `v1.2.3`) and
  # omit unrelated tags (e.g., `helm-chart-v2.0.3`).
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9e39e1d04396fd8f650f5d47c8157b681e57edf692db534c18403f34acf44291"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ed047d888622493bd0d0154bc7302a5cda37a233e61b214f123ba87a41df9c9b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d1e4d51aeb0abc36ec3f871ec25e2d8aa83ca7e760e849ee0f840ba352b571fc"
    sha256 cellar: :any_skip_relocation, ventura:        "9373ab7705dcddf04c4a873cbdd6d7d3b72e738d2f63bdd812e7fb51af55d2cf"
    sha256 cellar: :any_skip_relocation, monterey:       "66dd64d0de756725f8daa510592773233a8ddf9e24a58688506ac9b7c006e21b"
    sha256 cellar: :any_skip_relocation, big_sur:        "ca2d05f115a8c22c27bb29edbe0f3c96ef6ba68a25932eb2ab08e0080334cbbe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "60071832eab109f9ad50c01eea9fd78bf7328b003499ad96613ef1310fff63d5"
  end

  depends_on "go" => :build

  def install
    project = "github.com/kyverno/kyverno"
    ldflags = %W[
      -s -w
      -X #{project}/pkg/version.BuildVersion=#{version}
      -X #{project}/pkg/version.BuildHash=#{Utils.git_head}
      -X #{project}/pkg/version.BuildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/cli/kubectl-kyverno"

    generate_completions_from_executable(bin/"kyverno", "completion")
  end

  test do
    assert_match "Test Summary: 0 tests passed and 0 tests failed", shell_output("#{bin}/kyverno test .")

    assert_match version.to_s, "#{bin}/kyverno version"
  end
end
