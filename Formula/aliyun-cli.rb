class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
      tag:      "v3.0.139",
      revision: "ccf60ac3c6b7cbe815f698c2223f63380ba27ca7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cdea596a98376e05f5d4d5f4e823f06ba8b98f0b4e027d8445f02e15a6e5eb81"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "093db01418cf0f7d7c63830254ab4192e36cc8cdb238811c544232204fecfc36"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6730fe15f9f563d86dd997c9b2e421de6b75a5cbec67d64e97c739f1cfdf1f5d"
    sha256 cellar: :any_skip_relocation, ventura:        "4efe3324d3678576eb98e94b68c9167e956d2dea3377932d575073c666401e7e"
    sha256 cellar: :any_skip_relocation, monterey:       "c0f5fd8596964351994a5786c308256ab0d7766854a8612d8b9da0f16d121e5d"
    sha256 cellar: :any_skip_relocation, big_sur:        "dc9971f7151bb64daa683fb9ea561532cc1290791e1ef52eed545ecbfdb35f7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "96f253de46265818e486fc9732aa4404fc0c611ca577772e7da2ba9a30917673"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/aliyun/aliyun-cli/cli.Version=#{version}"
    system "go", "build", *std_go_args(output: bin/"aliyun", ldflags: ldflags), "main/main.go"
  end

  test do
    version_out = shell_output("#{bin}/aliyun version")
    assert_match version.to_s, version_out

    help_out = shell_output("#{bin}/aliyun --help")
    assert_match "Alibaba Cloud Command Line Interface Version #{version}", help_out
    assert_match "", help_out
    assert_match "Usage:", help_out
    assert_match "aliyun <product> <operation> [--parameter1 value1 --parameter2 value2 ...]", help_out

    oss_out = shell_output("#{bin}/aliyun oss")
    assert_match "Object Storage Service", oss_out
    assert_match "aliyun oss [command] [args...] [options...]", oss_out
  end
end
