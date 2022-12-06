require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.1.67.tgz"
  sha256 "a58617cf118a1eac54dcc5b2eeb715b15a01d5178d87de6b1759557e33f4ab64"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "80f612c318be304c84dfbd9b15b104b7b3b997eccc0808bdacca52068b628bcd"
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
