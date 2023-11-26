require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.186.0.tgz"
  sha256 "22833995c759e0d363c7d7256861299c1db434818f186ca18d88da798688e08b"
  license "Apache-2.0"
  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bb04f3c287f428177c2fffc17f2340163248326352b60d616c02941eb83f7911"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bb04f3c287f428177c2fffc17f2340163248326352b60d616c02941eb83f7911"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bb04f3c287f428177c2fffc17f2340163248326352b60d616c02941eb83f7911"
    sha256 cellar: :any_skip_relocation, sonoma:         "a843485473f1d75d831703db09f9bd6323950bd745d8b9a503bf9f0ec17b9a71"
    sha256 cellar: :any_skip_relocation, ventura:        "a843485473f1d75d831703db09f9bd6323950bd745d8b9a503bf9f0ec17b9a71"
    sha256 cellar: :any_skip_relocation, monterey:       "a843485473f1d75d831703db09f9bd6323950bd745d8b9a503bf9f0ec17b9a71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bb04f3c287f428177c2fffc17f2340163248326352b60d616c02941eb83f7911"
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
