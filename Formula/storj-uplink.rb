class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https://storj.io"
  url "https://github.com/storj/storj/archive/refs/tags/v1.68.2.tar.gz"
  sha256 "024629df45fb7434c790b88f1908dab4af69aa19f02cf1215da57947e02814ee"
  license "AGPL-3.0-only"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b07611217ecf6f9a24f2c38b860d94ceb289b0a264bdb1ae7111907bddc41af0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "878e52b794bca9559969d9594cb54be8a78726bfc4d1341706d6cf131254798e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "122a2ae1f13a3e0c2cec2caacfe898c8d79173d9be5c104259a2621ae9a8d422"
    sha256 cellar: :any_skip_relocation, ventura:        "f09c42c8a3e0c35d970ad0e2682a21ad7ac9a45b22c0a6f1fed9955551ab4205"
    sha256 cellar: :any_skip_relocation, monterey:       "d4c6f393a8cc9743e7fecee9b8593d174c59b480044673f0e54932bd5aaf2230"
    sha256 cellar: :any_skip_relocation, big_sur:        "eb3733cb017f9f94b74120b720453e89af03841be76a156b4cae42dcb9bf023a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9b96e462373fe06561f442565361bc81a24b3719faf5f8b88da19cf6743aacda"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"uplink"), "./cmd/uplink"
  end

  test do
    (testpath/"config.ini").write <<~EOS
      [metrics]
      addr=
    EOS
    ENV["UPLINK_CONFIG_DIR"] = testpath.to_s
    ENV["UPLINK_INTERACTIVE"] = "false"
    assert_match "No accesses configured", shell_output("#{bin}/uplink ls 2>&1", 1)
  end
end
