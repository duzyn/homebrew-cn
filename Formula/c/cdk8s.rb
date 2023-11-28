require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.190.0.tgz"
  sha256 "bd1007a1de8d2fb26c9831bac7bfdac6875569b4fea27cc57cbb975a861d2a66"
  license "Apache-2.0"
  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "63f48b433af8b541ab7cfe6a86d55b55e5772c00f274ab421020d4b6fe63fe88"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "63f48b433af8b541ab7cfe6a86d55b55e5772c00f274ab421020d4b6fe63fe88"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "63f48b433af8b541ab7cfe6a86d55b55e5772c00f274ab421020d4b6fe63fe88"
    sha256 cellar: :any_skip_relocation, sonoma:         "c2673719d5ca53e8b858ae8310574d8f139569905631c86d00b5f745ff4c7fb1"
    sha256 cellar: :any_skip_relocation, ventura:        "c2673719d5ca53e8b858ae8310574d8f139569905631c86d00b5f745ff4c7fb1"
    sha256 cellar: :any_skip_relocation, monterey:       "c2673719d5ca53e8b858ae8310574d8f139569905631c86d00b5f745ff4c7fb1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "63f48b433af8b541ab7cfe6a86d55b55e5772c00f274ab421020d4b6fe63fe88"
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
