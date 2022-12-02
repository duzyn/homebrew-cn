require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.1.63.tgz"
  sha256 "6aa616908c8644fba46f9c0f107464668e9e7b0b780312a5928432e34857c26c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1bb6dee04fa6feefe488944e4c764d0364af29774c9c880608b5803a92b40959"
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
