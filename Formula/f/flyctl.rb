class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.1.98",
      revision: "51a1b8f6bcb8e3b5106f6ea114e232dc35fdebc7"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4548966ef7878e00641e16b847f5f0c54a018db82772bf686a157172d3a0b0bc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4548966ef7878e00641e16b847f5f0c54a018db82772bf686a157172d3a0b0bc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4548966ef7878e00641e16b847f5f0c54a018db82772bf686a157172d3a0b0bc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4548966ef7878e00641e16b847f5f0c54a018db82772bf686a157172d3a0b0bc"
    sha256 cellar: :any_skip_relocation, sonoma:         "822c78c5883b035bd0b012b6c7d1c9dde903cc5c66dd09410d6afc0d71cb8a0d"
    sha256 cellar: :any_skip_relocation, ventura:        "822c78c5883b035bd0b012b6c7d1c9dde903cc5c66dd09410d6afc0d71cb8a0d"
    sha256 cellar: :any_skip_relocation, monterey:       "822c78c5883b035bd0b012b6c7d1c9dde903cc5c66dd09410d6afc0d71cb8a0d"
    sha256 cellar: :any_skip_relocation, big_sur:        "822c78c5883b035bd0b012b6c7d1c9dde903cc5c66dd09410d6afc0d71cb8a0d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e223b9ee4560a3a08dc666234a6b8b517a4c2a6479dfb67be3dffa2570b7cd8e"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -s -w
      -X github.com/superfly/flyctl/internal/buildinfo.environment=production
      -X github.com/superfly/flyctl/internal/buildinfo.buildDate=#{time.iso8601}
      -X github.com/superfly/flyctl/internal/buildinfo.version=#{version}
      -X github.com/superfly/flyctl/internal/buildinfo.commit=#{Utils.git_short_head}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    bin.install_symlink "flyctl" => "fly"

    generate_completions_from_executable(bin/"flyctl", "completion")
  end

  test do
    assert_match "flyctl v#{version}", shell_output("#{bin}/flyctl version")

    flyctl_status = shell_output("#{bin}/flyctl status 2>&1", 1)
    assert_match "Error: No access token available. Please login with 'flyctl auth login'", flyctl_status
  end
end
