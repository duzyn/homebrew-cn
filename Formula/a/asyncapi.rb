require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-1.2.7.tgz"
  sha256 "ad7864635bd3b14f391a086bd76afb02221fb0a04a7d52d71f7240b685b3bb36"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "451b428f2a907173313b8eb80543c260c83fa929007df016a6e4bde4680bd16a"
    sha256 cellar: :any,                 arm64_ventura:  "451b428f2a907173313b8eb80543c260c83fa929007df016a6e4bde4680bd16a"
    sha256 cellar: :any,                 arm64_monterey: "451b428f2a907173313b8eb80543c260c83fa929007df016a6e4bde4680bd16a"
    sha256 cellar: :any,                 sonoma:         "54dfa1da249caa1204912398731a7d2148197148d059ac08db7e954c51b01a4d"
    sha256 cellar: :any,                 ventura:        "54dfa1da249caa1204912398731a7d2148197148d059ac08db7e954c51b01a4d"
    sha256 cellar: :any,                 monterey:       "54dfa1da249caa1204912398731a7d2148197148d059ac08db7e954c51b01a4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "68c39d714e5c2f4883d7992f32a879af5a98e0116cf20c58960e0eba93c01742"
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
