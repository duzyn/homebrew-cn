class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.7.99",
      revision: "d4643454e1cb1f9b16077b7a663d3767fccf4276"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "fe69028c0392c766dc1e1d00c79ff6502f86d4cf84f656f1ec77ff925968e53c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fe69028c0392c766dc1e1d00c79ff6502f86d4cf84f656f1ec77ff925968e53c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fe69028c0392c766dc1e1d00c79ff6502f86d4cf84f656f1ec77ff925968e53c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fe69028c0392c766dc1e1d00c79ff6502f86d4cf84f656f1ec77ff925968e53c"
    sha256 cellar: :any_skip_relocation, sonoma:         "29d8df6f337935dc1e313caac91873c252c710da11a862a25a9a1f1ee305c40d"
    sha256 cellar: :any_skip_relocation, ventura:        "29d8df6f337935dc1e313caac91873c252c710da11a862a25a9a1f1ee305c40d"
    sha256 cellar: :any_skip_relocation, monterey:       "29d8df6f337935dc1e313caac91873c252c710da11a862a25a9a1f1ee305c40d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9b8ac6392677339b65ba94ee3ab1f728af2b73f1c559c54cc51db58c2e8552b2"
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
