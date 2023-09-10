class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.137",
      revision: "2345745f5cd5d46a756a900f06411e32545665e5"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5a4cbaba71cf3befea2a217d0bbee48901ffd1c8cd38b90e37229a0cea4678b4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5a4cbaba71cf3befea2a217d0bbee48901ffd1c8cd38b90e37229a0cea4678b4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5a4cbaba71cf3befea2a217d0bbee48901ffd1c8cd38b90e37229a0cea4678b4"
    sha256 cellar: :any_skip_relocation, ventura:        "84945959aeec6c50893f37852f8b3419c9eb1bdc5851a320758fc54417e87bbf"
    sha256 cellar: :any_skip_relocation, monterey:       "84945959aeec6c50893f37852f8b3419c9eb1bdc5851a320758fc54417e87bbf"
    sha256 cellar: :any_skip_relocation, big_sur:        "84945959aeec6c50893f37852f8b3419c9eb1bdc5851a320758fc54417e87bbf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e0d5b1cf8c38539a3c02f0e27d6c05e4b2e9df5acbc3ad7d45d347804a2b2cbe"
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
