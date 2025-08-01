class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.3.164",
      revision: "f767253a8e91ffc2706346c8366b597dfc455a98"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3e5afd40705487292ecf4c30c027be095314d1a84e17c21ca1a7d5979285d698"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3e5afd40705487292ecf4c30c027be095314d1a84e17c21ca1a7d5979285d698"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3e5afd40705487292ecf4c30c027be095314d1a84e17c21ca1a7d5979285d698"
    sha256 cellar: :any_skip_relocation, sonoma:        "701084625899404ba39afcffcbc4c5d63885d16e702b991dc99f218fb7291a64"
    sha256 cellar: :any_skip_relocation, ventura:       "701084625899404ba39afcffcbc4c5d63885d16e702b991dc99f218fb7291a64"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "437e08886189c6add6d02d057a3dffeebd985a4fc921e17f19395543bef63a85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bb04c70fafc2725ff3cb1e62e33cf5f12819a578caa0a04732b580268149d505"
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
    system "go", "build", *std_go_args(ldflags:, tags: "production")

    bin.install_symlink "flyctl" => "fly"

    generate_completions_from_executable(bin/"flyctl", "completion")
    generate_completions_from_executable(bin/"fly", "completion")
  end

  test do
    assert_match "flyctl v#{version}", shell_output("#{bin}/flyctl version")

    flyctl_status = shell_output("#{bin}/flyctl status 2>&1", 1)
    assert_match "Error: No access token available. Please login with 'flyctl auth login'", flyctl_status
  end
end
