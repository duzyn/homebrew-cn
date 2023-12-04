require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.197.0.tgz"
  sha256 "030a4997dcc1dfc2ecfddbe19249e4a3e2d44df2467174ae14defebfbc736bda"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fe25636365cca3ee964326d637a4351b26f9d2d3b9857355406bae18a85e25e2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fe25636365cca3ee964326d637a4351b26f9d2d3b9857355406bae18a85e25e2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fe25636365cca3ee964326d637a4351b26f9d2d3b9857355406bae18a85e25e2"
    sha256 cellar: :any_skip_relocation, sonoma:         "22873c5c516bbb2dedb71132efde1be888f0440b2c7d33dab505cbc368bc7a0a"
    sha256 cellar: :any_skip_relocation, ventura:        "22873c5c516bbb2dedb71132efde1be888f0440b2c7d33dab505cbc368bc7a0a"
    sha256 cellar: :any_skip_relocation, monterey:       "22873c5c516bbb2dedb71132efde1be888f0440b2c7d33dab505cbc368bc7a0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fe25636365cca3ee964326d637a4351b26f9d2d3b9857355406bae18a85e25e2"
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
