class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.7.158",
      revision: "4086136dddba33ce79b954c6ddd6e96e5d9f5606"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "814048b05a9322aef7fbc809f4c92ca400ab22890c665b263f9ceee4a99f1cdb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "814048b05a9322aef7fbc809f4c92ca400ab22890c665b263f9ceee4a99f1cdb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "814048b05a9322aef7fbc809f4c92ca400ab22890c665b263f9ceee4a99f1cdb"
    sha256 cellar: :any_skip_relocation, sonoma:        "ae7b98f4333698e5edb1299a8a0b32eaedef15db6181497f829923a4a357ecd0"
    sha256 cellar: :any_skip_relocation, ventura:       "ae7b98f4333698e5edb1299a8a0b32eaedef15db6181497f829923a4a357ecd0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8754ab254bfbc6d41511835bab0439b19d315e134fa7dd8c8c27ea653a4d00a0"
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
