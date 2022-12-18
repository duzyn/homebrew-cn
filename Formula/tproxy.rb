class Tproxy < Formula
  desc "CLI tool to proxy and analyze TCP connections"
  homepage "https://github.com/kevwan/tproxy"
  url "https://github.com/kevwan/tproxy/archive/refs/tags/v0.6.2.tar.gz"
  sha256 "d2269af0fc93ebf9d691bc7d25262aeb43ea01309290c90c0996ed2b9392b8e2"
  license "MIT"
  head "https://github.com/kevwan/tproxy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f22a98b690f512ea95c368cb52dfa7862eead7e99744e833acb62619d708bbfe"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5d212a2006c0a097579097cb31440cac448698d534359b82ea3d0ea90bc26067"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "76cf182e2ffda3bde0924447d1d9eefb02ad8b145cf7004f9cae899dec09045b"
    sha256 cellar: :any_skip_relocation, ventura:        "d0267f7e63e1f58a1793b82eb985598932ddd3c00368f77d289401f435841e4f"
    sha256 cellar: :any_skip_relocation, monterey:       "64c3e6c49c29fe57ba828f31eac65a7b7c21a186461f6b528de19748fb24b376"
    sha256 cellar: :any_skip_relocation, big_sur:        "b55f46e20d4dc4bc0201d585951a7533a3337b8e887f6fc718f152711c8a8c52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f07017814160af91024622c86beb92f63bdc1b60fc4e5a89ca4f0de61476ecb4"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    require "pty"
    port = free_port

    # proxy localhost:80 with delay of 100ms
    r, _, pid = PTY.spawn("#{bin}/tproxy -p #{port} -r localhost:80 -d 100ms")
    assert_match "Listening on 127.0.0.1:#{port}", r.readline
  ensure
    Process.kill("TERM", pid)
  end
end
