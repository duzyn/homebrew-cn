class Xq < Formula
  desc "Command-line XML and HTML beautifier and content extractor"
  homepage "https://github.com/sibprogrammer/xq"
  url "https://github.com/sibprogrammer/xq.git",
      tag:      "v1.1.0",
      revision: "0a9c1d7b705b5926328576b4a3a3ec2e3430e59c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eee62745373a047ed26f6c5b634bf3f1a1339bceb57e6b13989a018ec48ba011"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eee62745373a047ed26f6c5b634bf3f1a1339bceb57e6b13989a018ec48ba011"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "eee62745373a047ed26f6c5b634bf3f1a1339bceb57e6b13989a018ec48ba011"
    sha256 cellar: :any_skip_relocation, ventura:        "4678cf39f8f7523c79e1132e9d3c1cab7e907b06ffd16e819bad5e3e5543e152"
    sha256 cellar: :any_skip_relocation, monterey:       "4678cf39f8f7523c79e1132e9d3c1cab7e907b06ffd16e819bad5e3e5543e152"
    sha256 cellar: :any_skip_relocation, big_sur:        "4678cf39f8f7523c79e1132e9d3c1cab7e907b06ffd16e819bad5e3e5543e152"
    sha256 cellar: :any_skip_relocation, catalina:       "4678cf39f8f7523c79e1132e9d3c1cab7e907b06ffd16e819bad5e3e5543e152"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0ddaa61c9f713c77d59eb0dfd6b0f40bae4aa00b5ddd52850f13cbc8923daee8"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -s -w
      -X main.commit=#{Utils.git_head}
      -X main.version=#{version}
      -X main.date=#{time.rfc3339}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags)
    man1.install "docs/xq.man" => "xq.1"
  end

  test do
    version_output = shell_output(bin/"xq --version 2>&1")
    assert_match "xq version #{version}", version_output

    run_output = pipe_output(bin/"xq", "<root></root>")
    assert_match("<root/>", run_output)
  end
end
