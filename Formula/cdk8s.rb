require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.1.77.tgz"
  sha256 "28081705b7916914fab27fb1199c7db2d66572788dc1831ef3b3cdc8022a6841"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7d5e4ae8e04d5ff9abe01b40492b57a31d5b450c018ea5dda62287171d5dd9a8"
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
