class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.7.132",
      revision: "5023acbcf4d4149418749016bab67f854bda8c6b"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dc75e315f3651b668bcb69a8b324356d542a6139660dc96423e0742ee47ab78f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dc75e315f3651b668bcb69a8b324356d542a6139660dc96423e0742ee47ab78f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dc75e315f3651b668bcb69a8b324356d542a6139660dc96423e0742ee47ab78f"
    sha256 cellar: :any_skip_relocation, sonoma:        "13517d6001d54a55bc83b4e8dba45677708a48c9b933910b08870b7608f88c28"
    sha256 cellar: :any_skip_relocation, ventura:       "13517d6001d54a55bc83b4e8dba45677708a48c9b933910b08870b7608f88c28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "412708f8a497ad87d28ed40a28825c00d9e6d05ac1d9569da8c0c685518ab68e"
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

    system "go", "build", *std_go_args(ldflags:), "./mesheryctl/cmd/mesheryctl"

    generate_completions_from_executable(bin/"mesheryctl", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mesheryctl version 2>&1")
    assert_match "Channel: stable", shell_output("#{bin}/mesheryctl system channel view 2>&1")

    # Test kubernetes error on trying to start meshery
    assert_match "The Kubernetes cluster is not accessible.", shell_output("#{bin}/mesheryctl system start 2>&1", 1)
  end
end
