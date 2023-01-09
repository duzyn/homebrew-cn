class Livekit < Formula
  desc "Scalable, high-performance WebRTC server"
  homepage "https://livekit.io"
  url "https://github.com/livekit/livekit/archive/refs/tags/v1.3.3.tar.gz"
  sha256 "9569e5203d7f4d3089517e390f21971fc1b3bf9255ba3e4c27eaafdba55ac403"
  license "Apache-2.0"
  head "https://github.com/livekit/livekit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5554b6676580513529104a1451337a30ba1a3e9630632852512a07dc52a92fdf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "64a765364b27403f927448426e9fb2f399dc7caee0efe5ae41e160c60e0b810d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c60be675e80f4f88d7432398fdead0f0fb924468c82be85bc51d604caf0d335b"
    sha256 cellar: :any_skip_relocation, ventura:        "812c9cde9bb51a8c846c0218ebaf7bd765509fb1037a26293efe998dc9219e39"
    sha256 cellar: :any_skip_relocation, monterey:       "5cf2ec8c1ec66b3a82173abc176928f188039b9b008b80de051a458029d649f7"
    sha256 cellar: :any_skip_relocation, big_sur:        "fbfc79d817fc7a4c8f83a70cbf3a487a598d2408b4bcd2b76597a8c50375ba1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "da604f70830fcfbe69443aeae81f76e1dba8c10469f393d862b856bf33beeef2"
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
