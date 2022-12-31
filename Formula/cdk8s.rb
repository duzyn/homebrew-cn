require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.1.90.tgz"
  sha256 "e7b5e2782621f8900ce3ffd28b2b8ec0aa55b7be708aefa238131690672d6a60"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "fc4ce767a42564354a802c5fbf7e63a2028b46c0fb342d1c7f6edc11ad6338ab"
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
