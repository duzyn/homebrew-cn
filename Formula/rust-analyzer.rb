class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
       tag:      "2022-12-19",
       revision: "9ed1829f1fb61695c21474361ec23b9976793b73"
  version "2022-12-19"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a3deecd290e53c66678f62b81cc2adde28bfc7d5b5f460d064c5200350091267"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2a12aacc91e5640bad5119884e44e71c1f9b029b71e38d3853e716c58c3dcec5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fd40bed31f8ff5c452482b2e873bf24d7030c2983495cfcac0669c82d213b606"
    sha256 cellar: :any_skip_relocation, ventura:        "41f0f683281ed0162d1e281c3261311dd75a21f7af2811f90b757dc30b7cd993"
    sha256 cellar: :any_skip_relocation, monterey:       "42ace9264822c4e1baf048c240131bf0b16ed7d0fd0293ed8edb1f7969e64bc6"
    sha256 cellar: :any_skip_relocation, big_sur:        "41f0d3d9d8f5c1f9a7f80a760e88a4dd29fa1d4c2ae01901e7ac22eede5b9b0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "479fbe8b35f7ac401718d2e2849b49f54d30f98e90cb89942a985db8045ae103"
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
