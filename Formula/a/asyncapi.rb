require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-1.1.6.tgz"
  sha256 "227a3f4bbcc9e1261296ca48047a3c82d7bc5847a1c966496e284699e432bc45"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a97ccbf997bd0a242e58e46ec5fa4ad6391e658c243c0cc00be808e1aef169dc"
    sha256 cellar: :any,                 arm64_ventura:  "a97ccbf997bd0a242e58e46ec5fa4ad6391e658c243c0cc00be808e1aef169dc"
    sha256 cellar: :any,                 arm64_monterey: "a97ccbf997bd0a242e58e46ec5fa4ad6391e658c243c0cc00be808e1aef169dc"
    sha256 cellar: :any,                 sonoma:         "c60889fe42beec8537b0e035e273a02490c3296cb4a05cd50019bd997bc174bf"
    sha256 cellar: :any,                 ventura:        "c60889fe42beec8537b0e035e273a02490c3296cb4a05cd50019bd997bc174bf"
    sha256 cellar: :any,                 monterey:       "c60889fe42beec8537b0e035e273a02490c3296cb4a05cd50019bd997bc174bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9b77fc3a4be0ea35d87255ba7d2ebe34aed4900714f56b3b4e0bff2fc199b4f3"
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
