require "language/node"

class BashLanguageServer < Formula
  desc "Language Server for Bash"
  homepage "https://github.com/bash-lsp/bash-language-server"
  url "https://registry.npmjs.org/bash-language-server/-/bash-language-server-4.1.3.tgz"
  sha256 "e90df45348c41f7b57185a5861469715f22f927bb5b7f98d3aa787838e2cbc7c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d376ce0fb4ce78603a1c140e84a3d0f03277e3e7a722b8b8ff448ce77988006a"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    json = <<~JSON
      {
        "jsonrpc": "2.0",
        "id": 1,
        "method": "initialize",
        "params": {
          "rootUri": null,
          "capabilities": {}
        }
      }
    JSON
    input = "Content-Length: #{json.size}\r\n\r\n#{json}"
    output = pipe_output("#{bin}/bash-language-server start", input, 0)
    assert_match(/^Content-Length: \d+/i, output)
  end
end
