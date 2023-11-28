class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.182",
      revision: "e2b6a79646db587e475b4dfd431b75e34b310848"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b757dd1579e22e014ca8ded7d3efb20ed967ad9955be260adc1b7d8d8caf6058"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b757dd1579e22e014ca8ded7d3efb20ed967ad9955be260adc1b7d8d8caf6058"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b757dd1579e22e014ca8ded7d3efb20ed967ad9955be260adc1b7d8d8caf6058"
    sha256 cellar: :any_skip_relocation, sonoma:         "c2913a132e92d76c22fbd6fd28b99ee734e6315c64e70239af8a364e208b88f6"
    sha256 cellar: :any_skip_relocation, ventura:        "c2913a132e92d76c22fbd6fd28b99ee734e6315c64e70239af8a364e208b88f6"
    sha256 cellar: :any_skip_relocation, monterey:       "c2913a132e92d76c22fbd6fd28b99ee734e6315c64e70239af8a364e208b88f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b735f1a3fd303f5086e66df571b3e57fe20da527c67d09a39742da88910780e9"
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
