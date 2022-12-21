class Xq < Formula
  desc "Command-line XML and HTML beautifier and content extractor"
  homepage "https://github.com/sibprogrammer/xq"
  url "https://github.com/sibprogrammer/xq.git",
      tag:      "v1.1.1",
      revision: "f0c2fb2fb0dcc90e9422a219ffdf437113777388"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8342fb5d179c3a1a35edc633b2788f816dbb3afa692b66f27f413e2bc753a46d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8342fb5d179c3a1a35edc633b2788f816dbb3afa692b66f27f413e2bc753a46d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8342fb5d179c3a1a35edc633b2788f816dbb3afa692b66f27f413e2bc753a46d"
    sha256 cellar: :any_skip_relocation, ventura:        "38ce8f448da01dc0d58ff99ef2020fee358afb05a6f42c5dfaeeedbdfbaeab84"
    sha256 cellar: :any_skip_relocation, monterey:       "38ce8f448da01dc0d58ff99ef2020fee358afb05a6f42c5dfaeeedbdfbaeab84"
    sha256 cellar: :any_skip_relocation, big_sur:        "38ce8f448da01dc0d58ff99ef2020fee358afb05a6f42c5dfaeeedbdfbaeab84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "deaedc43048a49036c417b2a5d284e9f9c2149846105a66b4cc2b34b56315ccf"
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
