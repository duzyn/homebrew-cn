class Neosync < Formula
  desc "CLI for interfacing with Neosync"
  homepage "https://www.neosync.dev/"
  url "https://mirror.ghproxy.com/https://github.com/nucleuscloud/neosync/archive/refs/tags/v0.5.5.tar.gz"
  sha256 "97c885caf7b14d74b6953efdefa5905d7ae4a4d3e2d19fa24fd4b3c542b656bc"
  license "MIT"
  head "https://github.com/nucleuscloud/neosync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2239d8f2dc5f4102e141fa200ebe47035476471b9b7f8cdfe18205825c0c66aa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2239d8f2dc5f4102e141fa200ebe47035476471b9b7f8cdfe18205825c0c66aa"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2239d8f2dc5f4102e141fa200ebe47035476471b9b7f8cdfe18205825c0c66aa"
    sha256 cellar: :any_skip_relocation, sonoma:        "ecf65cab58881324d0b084aeec0419b1889921f4638601b093e4253711b65bb9"
    sha256 cellar: :any_skip_relocation, ventura:       "ecf65cab58881324d0b084aeec0419b1889921f4638601b093e4253711b65bb9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b331e64ea7e5f461424fdbb5ebca123c778e427455d5efa0a067f907e2af62c1"
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
    assert_match "connection refused", output

    assert_match version.to_s, shell_output("#{bin}/neosync --version")
  end
end
