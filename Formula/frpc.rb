class Frpc < Formula
  desc "Client app of fast reverse proxy to expose a local server to the internet"
  homepage "https://github.com/fatedier/frp"
  url "https://github.com/fatedier/frp.git",
      tag:      "v0.46.1",
      revision: "595aba5a9beaa61df8a226da3a0400118bd32c50"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5892d200779ee84a80b8aa75b92c1c5b26c29c61e5fc9dfae035821cdc8eb9ab"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5892d200779ee84a80b8aa75b92c1c5b26c29c61e5fc9dfae035821cdc8eb9ab"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5892d200779ee84a80b8aa75b92c1c5b26c29c61e5fc9dfae035821cdc8eb9ab"
    sha256 cellar: :any_skip_relocation, ventura:        "e4c7fe861d642563d835d4477f75cb97c17431d3a0453a379435e8ea326474b1"
    sha256 cellar: :any_skip_relocation, monterey:       "e4c7fe861d642563d835d4477f75cb97c17431d3a0453a379435e8ea326474b1"
    sha256 cellar: :any_skip_relocation, big_sur:        "e4c7fe861d642563d835d4477f75cb97c17431d3a0453a379435e8ea326474b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "23c7458da29508bb63887d0b4cf747c005954fa0bd4b9d7b69a0e5a664221571"
  end

  depends_on "go" => :build

  def install
    (buildpath/"bin").mkpath
    (etc/"frp").mkpath

    system "make", "frpc"
    bin.install "bin/frpc"
    etc.install "conf/frpc.ini" => "frp/frpc.ini"
    etc.install "conf/frpc_full.ini" => "frp/frpc_full.ini"
  end

  service do
    run [opt_bin/"frpc", "-c", etc/"frp/frpc.ini"]
    keep_alive true
    error_log_path var/"log/frpc.log"
    log_path var/"log/frpc.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/frpc -v")
    assert_match "Commands", shell_output("#{bin}/frpc help")
    assert_match "local_port", shell_output("#{bin}/frpc http", 1)
    assert_match "local_port", shell_output("#{bin}/frpc https", 1)
    assert_match "local_port", shell_output("#{bin}/frpc stcp", 1)
    assert_match "local_port", shell_output("#{bin}/frpc tcp", 1)
    assert_match "local_port", shell_output("#{bin}/frpc udp", 1)
    assert_match "local_port", shell_output("#{bin}/frpc xtcp", 1)
    assert_match "admin_port", shell_output("#{bin}/frpc status -c #{etc}/frp/frpc.ini", 1)
    assert_match "admin_port", shell_output("#{bin}/frpc reload -c #{etc}/frp/frpc.ini", 1)
  end
end
