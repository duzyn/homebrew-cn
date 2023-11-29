class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.184",
      revision: "0c7c8c1ac56b506819b5bd5a1814f30214e98307"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1d0b8fbdda072acc78054206e681e89f9a7e4adb47211d131ee60ac1446b0f97"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1d0b8fbdda072acc78054206e681e89f9a7e4adb47211d131ee60ac1446b0f97"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1d0b8fbdda072acc78054206e681e89f9a7e4adb47211d131ee60ac1446b0f97"
    sha256 cellar: :any_skip_relocation, sonoma:         "cacdc9991602d964be6955c36bbd6b7c48d44ab9ff858ca4c378fe7e588f8792"
    sha256 cellar: :any_skip_relocation, ventura:        "cacdc9991602d964be6955c36bbd6b7c48d44ab9ff858ca4c378fe7e588f8792"
    sha256 cellar: :any_skip_relocation, monterey:       "cacdc9991602d964be6955c36bbd6b7c48d44ab9ff858ca4c378fe7e588f8792"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1a6e2cabcb4d9525e8e1b4a1627899e0d506260281e18e6c2ec3707449d192d2"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"

    ldflags = %W[
      -s -w
      -X github.com/layer5io/meshery/mesheryctl/internal/cli/root/constants.version=v#{version}
      -X github.com/layer5io/meshery/mesheryctl/internal/cli/root/constants.commitsha=#{Utils.git_short_head}
      -X github.com/layer5io/meshery/mesheryctl/internal/cli/root/constants.releasechannel=stable
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "./mesheryctl/cmd/mesheryctl"

    generate_completions_from_executable(bin/"mesheryctl", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mesheryctl version 2>&1")
    assert_match "Channel: stable", shell_output("#{bin}/mesheryctl system channel view 2>&1")

    # Test kubernetes error on trying to start meshery
    assert_match "The Kubernetes cluster is not accessible.", shell_output("#{bin}/mesheryctl system start 2>&1", 1)
  end
end
