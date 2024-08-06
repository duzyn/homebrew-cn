class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https://blacktop.github.io/ipsw"
  url "https://mirror.ghproxy.com/https://github.com/blacktop/ipsw/archive/refs/tags/v3.1.531.tar.gz"
  sha256 "39b506c88b8eac59c90d12996578012929b5f43f6835e55ad9a4dab2e558668b"
  license "MIT"
  revision 1
  head "https://github.com/blacktop/ipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cd8b3a3f6ec3fc6fed1bd165edaa01a2056e0a3f9afe73eb57fc00020aacd260"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5a0248a9b673db79526733e0f22ca0e3d0b743f8d12aa9e9e5ab762395b3b2e1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ca95250d0c77be79080dadb8865869da8dce11fb34f07735dde494948488ce3b"
    sha256 cellar: :any_skip_relocation, sonoma:         "59e4712e41856148c61f2613f269856a6f7ee6c68c26c8496e6eeb0cd9e434e6"
    sha256 cellar: :any_skip_relocation, ventura:        "02c0d004aa91c569c99088bce1b9a0dde0875eaec49c768fea99a060e952f629"
    sha256 cellar: :any_skip_relocation, monterey:       "5fc1bc8c159b71bbef9255db2fc1d570aa4a00deb9e5217416f2c92e111bb12e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9271f801e77dcc849824b0a5e9a0c9043637282fae44476151a804e36a6eea20"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/blacktop/ipsw/cmd/ipsw/cmd.AppVersion=#{version}
      -X github.com/blacktop/ipsw/cmd/ipsw/cmd.AppBuildCommit=Homebrew
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/ipsw"
    generate_completions_from_executable(bin/"ipsw", "completion")
  end

  test do
    assert_match version.to_s, shell_output(bin/"ipsw version")

    assert_match "MacFamily20,1", shell_output(bin/"ipsw device-list")
  end
end
