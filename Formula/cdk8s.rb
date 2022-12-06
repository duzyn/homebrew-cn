require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.1.68.tgz"
  sha256 "1a840cf01bb3fb6aa1bc80813604f0775cafe3d2a558ce688251284ec1df7aae"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6c41956929bbaeb8973460dc5d39f7cd487abaa696c07efc42cc5cd7b1d2b356"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "Cannot initialize a project in a non-empty directory",
      shell_output("#{bin}/cdk8s init python-app 2>&1", 1)
  end
end
