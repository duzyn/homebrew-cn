require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.1.84.tgz"
  sha256 "1f27cbf5c7532b2ba95aa87e43cfda5a29a9bd41589dba8750681a459432f039"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7ee5e85df7f5d161ca27baef1111995c54607923a6ec5c30994f3f2e52bc8434"
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
