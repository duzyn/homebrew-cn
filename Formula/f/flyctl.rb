class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.3.162",
      revision: "9825f664107bbb13a5cef7ae067ae14f35dac196"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "531a5ceddc352171c1ee016b4778a5e6fa60f6f969bbd30358b428f29ed14d50"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "531a5ceddc352171c1ee016b4778a5e6fa60f6f969bbd30358b428f29ed14d50"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "531a5ceddc352171c1ee016b4778a5e6fa60f6f969bbd30358b428f29ed14d50"
    sha256 cellar: :any_skip_relocation, sonoma:        "58f97feb6d2f20b9836bc6fca4d7137d80204fdc9d56d8255eabb81f0a84b227"
    sha256 cellar: :any_skip_relocation, ventura:       "58f97feb6d2f20b9836bc6fca4d7137d80204fdc9d56d8255eabb81f0a84b227"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c8640a83ef2e29e8d0845022e529bc7cd80824456d39eccecfdbba4a7fcd93f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "42dc4a4857b958b2ca591ec7e26bebafb3537b02cea1d931230488d0ca6973a6"
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
