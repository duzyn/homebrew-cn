require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.1.61.tgz"
  sha256 "2a3ede0dc5cfd0c0f5641d1cb6797b4704abefc6325c2bdeec243ed12b264747"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2b5c1efada49c2d6ba402f9b6723ec2567e141abbe9bba02d3c5e8a0e3b0c1c0"
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
