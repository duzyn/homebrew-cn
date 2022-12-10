class Talisman < Formula
  desc "Tool to detect and prevent secrets from getting checked in"
  homepage "https://thoughtworks.github.io/talisman/"
  url "https://github.com/thoughtworks/talisman/archive/v1.29.4.tar.gz"
  sha256 "e0b3326cbad011914870ddee69b550707cc89c2d49a77f311b138040a59f5728"
  license "MIT"
  version_scheme 1
  head "https://github.com/thoughtworks/talisman.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "db4e7abdf8db1e9dcc78cc12b2eefbb839e5cce23e99104564977f80666bfbe5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "594ea96362ceb0f287d52d328d01582f08047b103be07f55b45bfcb173fd5338"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9648c1e7b38f66300bda671da53469a43e78a11ec3693d0cd953da3ded927bdd"
    sha256 cellar: :any_skip_relocation, ventura:        "bebcc5999ef8fdd6f0a57dfd3899d2375fb9dc1da73eac259c9c3e74a66311df"
    sha256 cellar: :any_skip_relocation, monterey:       "fab2a52a037a45adbfd18edbf7f640b002789a4b9f5a388a9d6aecba94cc5317"
    sha256 cellar: :any_skip_relocation, big_sur:        "7d96dee31d509f3f9c6203fe7469e87be1d5814d9137b9d6eb0a28b0b7dcc409"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6a027612a50e4e2427a0b522a9ec2bfe9f02088fdb3d5b53d7d3ca091dd3b766"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.Version=#{version}"), "./cmd"
  end

  test do
    system "git", "init", "."
    assert_match "talisman scan report", shell_output(bin/"talisman --scan")
  end
end
