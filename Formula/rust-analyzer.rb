class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
       tag:      "2022-12-12",
       revision: "21e61bee8b74e93f14205f4a6c316db08f811e38"
  version "2022-12-12"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9affde01a46897cd4abc7864fcc7e68d0c29bf00cb78394d90d43b3cb8cb780a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ef27f7d915b12714eebf7dec8bb2c314fe2924bf2f69ee44699b15510f9179db"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cc2ad145e380b8abdc38361f93476fb68e56f1381b64f6e2725189bc96242f80"
    sha256 cellar: :any_skip_relocation, ventura:        "d1f6b12f892ebb4f1ddd8ef336b411738522100caf9d01b7167e19acd7cb60ee"
    sha256 cellar: :any_skip_relocation, monterey:       "9db9fd94b0b76f5e852e70586ef87b9b13effc8908a61f469e4ef474e353be8e"
    sha256 cellar: :any_skip_relocation, big_sur:        "0f58c9c1fbd9e68e3f51d9acf1c153efcef58e48fe83a0677c64f8b83f9794d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bd6fc8f59d30da00d1098346fe25bfd7bb6016c7c2ec07beaf198ce9e0f18b44"
  end

  depends_on "rust" => :build

  def install
    cd "crates/rust-analyzer" do
      system "cargo", "install", "--bin", "rust-analyzer", *std_cargo_args
    end
  end

  def rpc(json)
    "Content-Length: #{json.size}\r\n" \
      "\r\n" \
      "#{json}"
  end

  test do
    input = rpc <<-EOF
    {
      "jsonrpc":"2.0",
      "id":1,
      "method":"initialize",
      "params": {
        "rootUri": "file:/dev/null",
        "capabilities": {}
      }
    }
    EOF

    input += rpc <<-EOF
    {
      "jsonrpc":"2.0",
      "method":"initialized",
      "params": {}
    }
    EOF

    input += rpc <<-EOF
    {
      "jsonrpc":"2.0",
      "id": 1,
      "method":"shutdown",
      "params": null
    }
    EOF

    input += rpc <<-EOF
    {
      "jsonrpc":"2.0",
      "method":"exit",
      "params": {}
    }
    EOF

    output = /Content-Length: \d+\r\n\r\n/

    assert_match output, pipe_output("#{bin}/rust-analyzer", input, 0)
  end
end
