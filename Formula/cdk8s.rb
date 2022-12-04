require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.1.65.tgz"
  sha256 "ef7ab56112c68741bae146cffa0d91d1625dba4be28200a83838332f0eee7615"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d3602db499c6d89852d5a9568aedcfdbb3199f920a8403f2e9af982c327247f0"
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
