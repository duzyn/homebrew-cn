require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.1.76.tgz"
  sha256 "d0fd4bc53fe1a5c0cc5c61b952a22c48cca8ede2c60c5d7156119cc4737b2bbb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8c6535eb45120d396cd8e5ab52ca87d586dcc73c8e03550d538cbbfe9f60322f"
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
