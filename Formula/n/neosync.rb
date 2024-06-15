class Neosync < Formula
  desc "CLI for interfacing with Neosync"
  homepage "https://www.neosync.dev/"
  url "https://mirror.ghproxy.com/https://github.com/nucleuscloud/neosync/archive/refs/tags/v0.4.33.tar.gz"
  sha256 "87938bcbae301f7ae7f2d30ee5e05a869291e176da611e573b5b2070955192ac"
  license "MIT"
  head "https://github.com/nucleuscloud/neosync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c222e7d95e7b5ff6a9342ffb63d7045daa4686c3c0cc04186aabe4ef1c42ab77"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4decb70f31afd9b10684cc5bdda72edb70b5e60899dca19bad78f555b2cfc021"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "401d1a41e1800b094c81b1cbb2fae976b2d8a12ee5344766321b64a734d2a7ba"
    sha256 cellar: :any_skip_relocation, sonoma:         "154f59122c24996a52199c36aa75128a48283d16b2fde6e8df6796af8d019f0d"
    sha256 cellar: :any_skip_relocation, ventura:        "32add51ec497e37b40a818332578a4d6a3c2422efe5a13d6c6906f1424efdc9f"
    sha256 cellar: :any_skip_relocation, monterey:       "a878f2a71f751dd3dfb3b27ccde332c1a38bae20d780c0a5dc35074320f8dde0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "48592a5c5d53520c1b0f8451c959b818e9a095e04ba8a2a00413be7a33c40dae"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/nucleuscloud/neosync/cli/internal/version.gitVersion=#{version}
      -X github.com/nucleuscloud/neosync/cli/internal/version.gitCommit=#{tap.user}
      -X github.com/nucleuscloud/neosync/cli/internal/version.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cli/cmd/neosync"

    generate_completions_from_executable(bin/"neosync", "completion")
  end

  test do
    output = shell_output("#{bin}/neosync connections list 2>&1", 1)
    assert_match "connect: connection refused", output

    assert_match version.to_s, shell_output("#{bin}/neosync --version")
  end
end
