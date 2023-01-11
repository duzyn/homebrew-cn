class Frps < Formula
  desc "Server app of fast reverse proxy to expose a local server to the internet"
  homepage "https://github.com/fatedier/frp"
  url "https://github.com/fatedier/frp.git",
      tag:      "v0.46.1",
      revision: "595aba5a9beaa61df8a226da3a0400118bd32c50"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "65320172a46c223b2d0c6b29068683baa6fbd2a4dbd74956b4eeb4c36f414835"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "65320172a46c223b2d0c6b29068683baa6fbd2a4dbd74956b4eeb4c36f414835"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "65320172a46c223b2d0c6b29068683baa6fbd2a4dbd74956b4eeb4c36f414835"
    sha256 cellar: :any_skip_relocation, ventura:        "a155d58b3a7a0cd6a0462160ac52d7db3ddc09fe041a3a40edb9993c649c226e"
    sha256 cellar: :any_skip_relocation, monterey:       "a155d58b3a7a0cd6a0462160ac52d7db3ddc09fe041a3a40edb9993c649c226e"
    sha256 cellar: :any_skip_relocation, big_sur:        "a155d58b3a7a0cd6a0462160ac52d7db3ddc09fe041a3a40edb9993c649c226e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c9f8e0e614543e5c967f14a21a1cbd3b38c9d90ed085180184a619f033bb0e65"
  end

  depends_on "go" => :build

  def install
    (buildpath/"bin").mkpath
    (etc/"frp").mkpath

    system "make", "frps"
    bin.install "bin/frps"
    etc.install "conf/frps.ini" => "frp/frps.ini"
    etc.install "conf/frps_full.ini" => "frp/frps_full.ini"
  end

  service do
    run [opt_bin/"frps", "-c", etc/"frp/frps.ini"]
    keep_alive true
    error_log_path var/"log/frps.log"
    log_path var/"log/frps.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/frps -v")
    assert_match "Flags", shell_output("#{bin}/frps --help")

    read, write = IO.pipe
    fork do
      exec bin/"frps", out: write
    end
    sleep 3

    output = read.gets
    assert_match "frps uses command line arguments for config", output
  end
end
