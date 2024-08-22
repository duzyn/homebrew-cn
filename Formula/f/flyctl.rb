class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.2.118",
      revision: "a7a30da947c4ce0675a0cb678f5bc684f2f8d0d6"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2611805128849f8ec01a2a329732eb311a84db5085b1be074045ccfd133e8726"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2611805128849f8ec01a2a329732eb311a84db5085b1be074045ccfd133e8726"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2611805128849f8ec01a2a329732eb311a84db5085b1be074045ccfd133e8726"
    sha256 cellar: :any_skip_relocation, sonoma:         "33bd5fbfcb6335fd110849cf53a982915b07d5c74e864facec92ccc16db06bf1"
    sha256 cellar: :any_skip_relocation, ventura:        "33bd5fbfcb6335fd110849cf53a982915b07d5c74e864facec92ccc16db06bf1"
    sha256 cellar: :any_skip_relocation, monterey:       "33bd5fbfcb6335fd110849cf53a982915b07d5c74e864facec92ccc16db06bf1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3c4b99083e4bd84d436e6f6bfd67082a38bfddecf4f0251a46e9d9cba96927bb"
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
