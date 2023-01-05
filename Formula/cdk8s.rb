require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.1.95.tgz"
  sha256 "13368503f9df64b8b9d6128cd11509b016117d3dfd831b958230d2f682dc330b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5af3c2052b4920915e507676acef0baf476924a7fe35c5acf232b10805e2d428"
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
