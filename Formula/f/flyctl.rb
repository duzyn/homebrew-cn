class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.2.43",
      revision: "61db38e4bac77a45a2dcecd104ffd5b887b88886"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  # Upstream tags versions like `v0.1.92` and `v2023.9.8` but, as of writing,
  # they only create releases for the former and those are the versions we use
  # in this formula. We could omit the date-based versions using a regex but
  # this uses the `GithubLatest` strategy, as the upstream repository also
  # contains over a thousand tags (and growing).
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d27808cc4d07418d5653c47c4300ba62ed5e965968a811067cdf490626e74141"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d27808cc4d07418d5653c47c4300ba62ed5e965968a811067cdf490626e74141"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d27808cc4d07418d5653c47c4300ba62ed5e965968a811067cdf490626e74141"
    sha256 cellar: :any_skip_relocation, sonoma:         "bc6f1615bd7776fec9775960a6b8bd7e28353f44cea4690072e98384645e6981"
    sha256 cellar: :any_skip_relocation, ventura:        "bc6f1615bd7776fec9775960a6b8bd7e28353f44cea4690072e98384645e6981"
    sha256 cellar: :any_skip_relocation, monterey:       "bc6f1615bd7776fec9775960a6b8bd7e28353f44cea4690072e98384645e6981"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "137f31de1610330cfb687bafa387b0d09e95034da88c7d2a6b039b77cf3b709f"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -s -w
      -X github.com/superfly/flyctl/internal/buildinfo.buildDate=#{time.iso8601}
      -X github.com/superfly/flyctl/internal/buildinfo.buildVersion=#{version}
      -X github.com/superfly/flyctl/internal/buildinfo.commit=#{Utils.git_short_head}
    ]
    system "go", "build", *std_go_args(ldflags:), "-tags", "production"

    bin.install_symlink "flyctl" => "fly"

    generate_completions_from_executable(bin/"flyctl", "completion")
  end

  test do
    assert_match "flyctl v#{version}", shell_output("#{bin}/flyctl version")

    flyctl_status = shell_output("#{bin}/flyctl status 2>&1", 1)
    assert_match "Error: No access token available. Please login with 'flyctl auth login'", flyctl_status
  end
end
