require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.1.69.tgz"
  sha256 "c826e486d68f8b7dc00aa3acf4754a4517bdb59ef8a8ffd90887e5c9f82d33c8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d572800b12f9bd708669a4babe80544c8f927d660218c0a7be27dd84ad9bbcb1"
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
