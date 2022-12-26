require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.1.86.tgz"
  sha256 "ea88def8a54f2fe8c6984936978dd489ac602fec4b1879c637f179f6b3bff245"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5cad79556951c757250934a1e9fe2893c0a83c8850deeefda5d7b43a93184231"
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
