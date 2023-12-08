class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.1.132",
      revision: "29140f93824b409bd56868c40aca6eb833e6b2de"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a263afdb634cdd2e6bb8d335429c46f5c1b11cd78fae4494f65af392046559af"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a263afdb634cdd2e6bb8d335429c46f5c1b11cd78fae4494f65af392046559af"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a263afdb634cdd2e6bb8d335429c46f5c1b11cd78fae4494f65af392046559af"
    sha256 cellar: :any_skip_relocation, sonoma:         "13d8e2b5ddd53d914cd8b41c5fe4e36a0b0837699b3ea39eb7b69fdc54ec54e3"
    sha256 cellar: :any_skip_relocation, ventura:        "13d8e2b5ddd53d914cd8b41c5fe4e36a0b0837699b3ea39eb7b69fdc54ec54e3"
    sha256 cellar: :any_skip_relocation, monterey:       "13d8e2b5ddd53d914cd8b41c5fe4e36a0b0837699b3ea39eb7b69fdc54ec54e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "56eceec6e8f6b3e2651be3316089dbe3d25781ecf70db5319ea251343e2baa44"
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
    system "go", "build", *std_go_args(ldflags: ldflags), "-tags", "production"

    bin.install_symlink "flyctl" => "fly"

    generate_completions_from_executable(bin/"flyctl", "completion")
  end

  test do
    assert_match "flyctl v#{version}", shell_output("#{bin}/flyctl version")

    flyctl_status = shell_output("#{bin}/flyctl status 2>&1", 1)
    assert_match "Error: No access token available. Please login with 'flyctl auth login'", flyctl_status
  end
end
