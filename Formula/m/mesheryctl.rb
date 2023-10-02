class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.152",
      revision: "e40763942fb785d160566d04463458884e03bd31"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8a3179f211c3d23df9baaada8f5e6642b7fa3eb7de1997f1afcf9c1f7ec326d0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8a3179f211c3d23df9baaada8f5e6642b7fa3eb7de1997f1afcf9c1f7ec326d0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8a3179f211c3d23df9baaada8f5e6642b7fa3eb7de1997f1afcf9c1f7ec326d0"
    sha256 cellar: :any_skip_relocation, sonoma:         "1dbea057f32c002d7713e39c18e564848af36b19276be062cd7905753d05da48"
    sha256 cellar: :any_skip_relocation, ventura:        "1dbea057f32c002d7713e39c18e564848af36b19276be062cd7905753d05da48"
    sha256 cellar: :any_skip_relocation, monterey:       "1dbea057f32c002d7713e39c18e564848af36b19276be062cd7905753d05da48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "58d2d861a05c817dc5b850265164e0db724a91f57637207e2d50913d80a56cfa"
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
