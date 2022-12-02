class Temporal < Formula
  desc "Command-line interface for running and interacting with Temporal Server and UI"
  homepage "https://temporal.io/"
  url "https://github.com/temporalio/cli/archive/v0.2.0.tar.gz"
  sha256 "b8f83e07f47994482b73e3288083f38635aaeb77de673920041307254363f5be"
  license "MIT"
  head "https://github.com/temporalio/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "70d116a8e4550bb1fcdb5c87f5140322fe3865a9f1dfcb4005618bcec6074741"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9a4c6dfb6ec136757572fb0894cc964895170e9987e7548a4288355a6becca05"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7c754f159a9f46385326e03f4a9515d84bfd68e653bf58f477411105dd2826b6"
    sha256 cellar: :any_skip_relocation, ventura:        "5df738ea399bffde9c91e9a629e6e332b472802cfeefd657fa0f46a4c649d1e1"
    sha256 cellar: :any_skip_relocation, monterey:       "a3249e13d4a241278cf681550614deaf21ea92352434665aa4fe28ba3d050078"
    sha256 cellar: :any_skip_relocation, big_sur:        "f7bb94266be632a5b3fafcaac74e03ef3fe9cc61316d3cbbfadc83262557c0a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e984162867e4e4c5f658bf2535bdb9e4455fbb214709f763fece99e50b3cae05"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/temporal"
  end

  test do
    run_output = shell_output("#{bin}/temporal --version")
    assert_match "temporal version #{version}", run_output

    run_output = shell_output("#{bin}/temporal workflow list --address 192.0.2.0:1234 2>&1", 1)
    assert_match "failed reaching server", run_output
  end
end
