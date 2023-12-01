require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-1.2.1.tgz"
  sha256 "7ed433c42262732da9e1ace55ef947749cd79ba48b866d772def2ae580b03624"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "8b7ea3ed66d070c5d56f19ed2c1c0a1d6c7da4153ec4867e1b995fcb53b889d5"
    sha256 cellar: :any,                 arm64_ventura:  "8b7ea3ed66d070c5d56f19ed2c1c0a1d6c7da4153ec4867e1b995fcb53b889d5"
    sha256 cellar: :any,                 arm64_monterey: "8b7ea3ed66d070c5d56f19ed2c1c0a1d6c7da4153ec4867e1b995fcb53b889d5"
    sha256 cellar: :any,                 sonoma:         "9e5a75386d9d77427597dd9405184587c0753ad6003a2d9786a45196e717d055"
    sha256 cellar: :any,                 ventura:        "9e5a75386d9d77427597dd9405184587c0753ad6003a2d9786a45196e717d055"
    sha256 cellar: :any,                 monterey:       "9e5a75386d9d77427597dd9405184587c0753ad6003a2d9786a45196e717d055"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9facc38fe4a3c7e8b2e5c13316b9323e07b25fcf76699686ecdbf9dc86d00494"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Delete native binaries installed by npm, as we dont support `musl` for a `libc` implementation
    node_modules = libexec/"lib/node_modules/@asyncapi/cli/node_modules"
    (node_modules/"@swc/core-linux-x64-musl/swc.linux-x64-musl.node").unlink if OS.linux?

    # Replace universal binaries with their native slices
    deuniversalize_machos
  end

  test do
    system bin/"asyncapi", "new", "--file-name=asyncapi.yml", "--example=default-example.yaml", "--no-tty"
    assert_predicate testpath/"asyncapi.yml", :exist?, "AsyncAPI file was not created"
  end
end
