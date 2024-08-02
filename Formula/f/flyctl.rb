class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.2.103",
      revision: "f4ae6f03c144e4d5ccbe454172c4d3bea6b1d85b"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d517df054ddc73531ef7ac6b9ac8dce404f3db4526bcd1ea5ce702660a09f072"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d517df054ddc73531ef7ac6b9ac8dce404f3db4526bcd1ea5ce702660a09f072"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d517df054ddc73531ef7ac6b9ac8dce404f3db4526bcd1ea5ce702660a09f072"
    sha256 cellar: :any_skip_relocation, sonoma:         "d8492d5f8ffa699a7d18f3f13b4d2f9ecfa8700b527640a1746bcf06a5733ea8"
    sha256 cellar: :any_skip_relocation, ventura:        "d8492d5f8ffa699a7d18f3f13b4d2f9ecfa8700b527640a1746bcf06a5733ea8"
    sha256 cellar: :any_skip_relocation, monterey:       "d8492d5f8ffa699a7d18f3f13b4d2f9ecfa8700b527640a1746bcf06a5733ea8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "914bea34f95dbed322a0593dfa71f0de844f533740156904a5d0544eb775d343"
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
