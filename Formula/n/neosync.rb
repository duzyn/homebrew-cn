class Neosync < Formula
  desc "CLI for interfacing with Neosync"
  homepage "https://www.neosync.dev/"
  url "https://mirror.ghproxy.com/https://github.com/nucleuscloud/neosync/archive/refs/tags/v0.4.12.tar.gz"
  sha256 "bd8acde142e37dfdc50dff474c62e5c38a6272a7a7882dbdd88f3ebd70658474"
  license "MIT"
  head "https://github.com/nucleuscloud/neosync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "98c86e4fd887f956aed0522198576aba57f465abf6f7a18d2ff9bde2aea8e255"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "df75ae6a5fed45e2c3fe1deb213296f9f2e0bbe605f5e1104413f745b39269d0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e550d5b50454fb606deadf5fd41adaf781692ef87f6ce85ad22539a38dbe2a0e"
    sha256 cellar: :any_skip_relocation, sonoma:         "0d84669bf95a665f4da16a10bc98400be9ee6ecbd6dac23a9e039e46dc6eb84c"
    sha256 cellar: :any_skip_relocation, ventura:        "afb4fc4c594cc8affb53d6c78daaa7e7a66e10f7c2128fff1671cb925a3b7de2"
    sha256 cellar: :any_skip_relocation, monterey:       "789861218d5bb53f650f575ac738f1b60f56327dc85c637606644b202aabb33d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5f485fd84201841b0bad85757306c537debcaa5541347c2aae19b9d671dba7ea"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/nucleuscloud/neosync/cli/internal/version.gitVersion=#{version}
      -X github.com/nucleuscloud/neosync/cli/internal/version.gitCommit=#{tap.user}
      -X github.com/nucleuscloud/neosync/cli/internal/version.buildDate=#{time.iso8601}
    ]
    cd "cli" do
      system "go", "build", *std_go_args(ldflags:), "./cmd/neosync"
    end

    generate_completions_from_executable(bin/"neosync", "completion")
  end

  test do
    output = shell_output("#{bin}/neosync connections list 2>&1", 1)
    assert_match "connect: connection refused", output

    assert_match version.to_s, shell_output("#{bin}/neosync --version")
  end
end
