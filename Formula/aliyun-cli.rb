class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
      tag:      "v3.0.140",
      revision: "550ccb6a9518e61f2bf188d682c2f4b398aa87a6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b441af8956d76d55a17f35fa76816f0af3caf0044c11466dfc4642996f3ef3ed"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7ced5bafc18c53abd7ea19c8d8ac6f164bd1d8c27eae201b3c6acbf12a62ee87"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "603cf6dafe9f78e5567b283c7a3d09d97ad67e39cbe55b563e1b6b9a19a8555c"
    sha256 cellar: :any_skip_relocation, ventura:        "44ec1a382914f2b83b5d08643b6a22bfcf3e9305af4aa53e6752c33bffe24d85"
    sha256 cellar: :any_skip_relocation, monterey:       "452f1fa1999a00af79dad74a15390a2b6b61ffab2b403319a5ade589ae19139e"
    sha256 cellar: :any_skip_relocation, big_sur:        "b796027ed4a36460c29096daf11d241ef41ef9baf165f14033f52ce7ade6d5be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8e8e0d46643efedc84fce0296be56e3476cb4acd900355cee31aa76515f8fcfe"
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
