class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https://blacktop.github.io/ipsw"
  url "https://mirror.ghproxy.com/https://github.com/blacktop/ipsw/archive/refs/tags/v3.1.579.tar.gz"
  sha256 "03f1c74cc7039cc006ba18b20a1ed0b5ae4394ed0493249b6a585c8d86e158ce"
  license "MIT"
  head "https://github.com/blacktop/ipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "61d12acd5fa65a0ef7cbf00402be030348a544f35643758c8affdbe2e59662eb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "14d165561177fc04b34a3d014e9fa1fb3ff234fa01f7051270eab388fe3517bc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e1921650166775afdb72639e8fcfdeab90b4a518ce3c8de5ad33714bc52d2355"
    sha256 cellar: :any_skip_relocation, sonoma:        "357674125ce4a129d22cbcf523533021fd85d8b788840977a1491be4020dfd81"
    sha256 cellar: :any_skip_relocation, ventura:       "b5a4df061c0c3463c503ee33ae975bdf9a1c7387ffd232f5af9398575bbf3bf3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7afec5e0d49ac631c3062c202b91da44cdb77637a19ba4d106edfc4d161d43b0"
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
