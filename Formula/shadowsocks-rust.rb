class ShadowsocksRust < Formula
  desc "Rust port of Shadowsocks"
  homepage "https://github.com/shadowsocks/shadowsocks-rust"
  url "https://github.com/shadowsocks/shadowsocks-rust/archive/v1.15.1.tar.gz"
  sha256 "afa6edd6532501583d1abb5c2767c3c7993e458e06c9787d0c5cecfaa6ed5e5f"
  license "MIT"
  head "https://github.com/shadowsocks/shadowsocks-rust.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "01ce4efea7dd6eb095b2f19c2ec3b30c1a9b0fbfb14df92c639e7ba9f5e0c63e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "faab39e96297659df0aad957c6b4636e6eb27082646cebed3c5576eac9bc90fc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7c38e0ddf273fc62a980fe16f2993cb0825831f6856770d6d88fdc6d534b78b6"
    sha256 cellar: :any_skip_relocation, ventura:        "017790ac50c8045c72a70ed1b916c4a6117369d22bdb7c571f4d6b192c9625fd"
    sha256 cellar: :any_skip_relocation, monterey:       "1b83989a87269b6fe19c2af4e829c35801c6b4eb174cab0fb483083aa15d3102"
    sha256 cellar: :any_skip_relocation, big_sur:        "fa0111aaa800fb62c4133a6171eb09a6f06ad5a2e85dc8a7a7c221e4ec473c1b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "59b5dffcc04d2ab0558d07bf07700d5c6f4305f5ca919effc18f04a911944b71"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    server_port = free_port
    local_port = free_port

    (testpath/"server.json").write <<~EOS
      {
          "server":"127.0.0.1",
          "server_port":#{server_port},
          "password":"mypassword",
          "method":"aes-256-gcm"
      }
    EOS
    (testpath/"local.json").write <<~EOS
      {
          "server":"127.0.0.1",
          "server_port":#{server_port},
          "password":"mypassword",
          "method":"aes-256-gcm",
          "local_address":"127.0.0.1",
          "local_port":#{local_port}
      }
    EOS
    fork { exec bin/"ssserver", "-c", testpath/"server.json" }
    fork { exec bin/"sslocal", "-c", testpath/"local.json" }
    sleep 3

    output = shell_output "curl --socks5 127.0.0.1:#{local_port} https://example.com"
    assert_match "Example Domain", output
  end
end
