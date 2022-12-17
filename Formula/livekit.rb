class Livekit < Formula
  desc "Scalable, high-performance WebRTC server"
  homepage "https://livekit.io"
  url "https://github.com/livekit/livekit/archive/refs/tags/v1.3.2.tar.gz"
  sha256 "014c9888ba86f19aa6fc65399505aaf832f9e227a1fc447a22b5713c8cf6e484"
  license "Apache-2.0"
  head "https://github.com/livekit/livekit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "62026f0ce1ce21e1a5b1e706d56da707a250a3b32a66fab849f9f79f545874dc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4df047cc1d315b3d335de8c04deede1a8409aec00850172872f2e51b3085b027"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b19e4eec245d6dae5cef68436892235076e5f5ba6a4eec901f4d9d2fa494c6dc"
    sha256 cellar: :any_skip_relocation, ventura:        "b439ffcfe18c96e05262d32b403cabcdf67abb4abf4ea07d158531c022de9393"
    sha256 cellar: :any_skip_relocation, monterey:       "a2c7f97cdb1aafffa50b1017a87474d71f963f4136c727b51e2c5130b39339b4"
    sha256 cellar: :any_skip_relocation, big_sur:        "71a6c1056ea90bfff2dc2dc22c4aee87a7bfc7972c507411d4f475ea9b017c01"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "24d365c2068d72afb07bfa638184d3ecb3ecce11b56b2c9351a01d451b4f9f09"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"livekit-server"), "./cmd/server"
  end

  test do
    http_port = free_port
    fork do
      exec bin/"livekit-server", "--keys", "test: key", "--config-body", "port: #{http_port}"
    end
    sleep 3
    assert_match "OK", shell_output("curl localhost:#{http_port}")

    output = shell_output("#{bin}/livekit-server --version")
    assert_match "livekit-server version #{version}", output
  end
end
