require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.169.0.tgz"
  sha256 "8ef603c65b5012d739654140bfed7ad48eb2b7b9127dbbab4e7617ecf612f492"
  license "Apache-2.0"
  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "60c24cfda53e8042d8a70984bdec84f299575bc01a9dd35850c81431d2c41dd9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "60c24cfda53e8042d8a70984bdec84f299575bc01a9dd35850c81431d2c41dd9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "60c24cfda53e8042d8a70984bdec84f299575bc01a9dd35850c81431d2c41dd9"
    sha256 cellar: :any_skip_relocation, sonoma:         "aaea64d9f998698020baa38e3be52494e5d91d61ab132e276119f7eccfcd3495"
    sha256 cellar: :any_skip_relocation, ventura:        "aaea64d9f998698020baa38e3be52494e5d91d61ab132e276119f7eccfcd3495"
    sha256 cellar: :any_skip_relocation, monterey:       "aaea64d9f998698020baa38e3be52494e5d91d61ab132e276119f7eccfcd3495"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "60c24cfda53e8042d8a70984bdec84f299575bc01a9dd35850c81431d2c41dd9"
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
