require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-1.1.8.tgz"
  sha256 "b25d221dda5fb7dbde2a992370a08ba1349d41747940361e08e5ce223ca18681"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b32ad0c3fb68d65f556adea3f2a137fc96dcbf2d58b91a03f6c07d4bfb564f21"
    sha256 cellar: :any,                 arm64_ventura:  "b32ad0c3fb68d65f556adea3f2a137fc96dcbf2d58b91a03f6c07d4bfb564f21"
    sha256 cellar: :any,                 arm64_monterey: "b32ad0c3fb68d65f556adea3f2a137fc96dcbf2d58b91a03f6c07d4bfb564f21"
    sha256 cellar: :any,                 sonoma:         "e22d4c4ec590b1816b3d54e1647f821fe86cbd57d3a208171ba7deb954e539b2"
    sha256 cellar: :any,                 ventura:        "e22d4c4ec590b1816b3d54e1647f821fe86cbd57d3a208171ba7deb954e539b2"
    sha256 cellar: :any,                 monterey:       "e22d4c4ec590b1816b3d54e1647f821fe86cbd57d3a208171ba7deb954e539b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7dad0e2654dfe5f7ab51b52e499780311cf272c103fd322636d7a3aeb55acac3"
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
