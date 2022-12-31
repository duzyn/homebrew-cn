class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
    tag:      "v1.60.4",
    revision: "9baaf4d2052da0d18504df1dce1d305ca5ac8aa4"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d5a9c1ec4665c4843bcdb5909ebea67a062626db2ca919d6cb22ddd818a8e601"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0110257fbb54ab0452ece1e97a47430960853c7c50901d7ffb8905ceac2822e7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "48a1706cd4e1279f320475e73dd0a85338db32e38cbf083e059dcc9c28dc82e7"
    sha256 cellar: :any_skip_relocation, ventura:        "304ea574cb122da976d2bddbb39a2e4e3caef0797863e031f94cc93cf68bda1d"
    sha256 cellar: :any_skip_relocation, monterey:       "c93116917f607ce10ad2699d125767b70c255b06e9d9843f53c31f3cd555282a"
    sha256 cellar: :any_skip_relocation, big_sur:        "870b8f05597e3d2d9922b7cc9883a52e881b0bd33a0453f65e251d0bb79fa0f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d8659900aabb52b090a56385c1a2a137d77bbdaebf6434c07e412388ce37854c"
  end

  depends_on "go" => :build

  def install
    arch = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s
    ldflags = %W[
      -s -w
      -X github.com/wakatime/wakatime-cli/pkg/version.Arch=#{arch}
      -X github.com/wakatime/wakatime-cli/pkg/version.BuildDate=#{time.iso8601}
      -X github.com/wakatime/wakatime-cli/pkg/version.Commit=#{Utils.git_head(length: 7)}
      -X github.com/wakatime/wakatime-cli/pkg/version.OS=#{OS.kernel_name.downcase}
      -X github.com/wakatime/wakatime-cli/pkg/version.Version=v#{version}
    ].join(" ")
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    output = shell_output("#{bin}/wakatime-cli --help 2>&1")
    assert_match "Command line interface used by all WakaTime text editor plugins", output
  end
end
