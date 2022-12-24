require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.16.25.tgz"
  sha256 "159182e1370cb5509fa40db1437e0d6873b055314baa5615d8669b9368132e6d"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c28541d62d98aef40be8154434cc4a195303456129e09e3a559a61bd056a24bd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c28541d62d98aef40be8154434cc4a195303456129e09e3a559a61bd056a24bd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c28541d62d98aef40be8154434cc4a195303456129e09e3a559a61bd056a24bd"
    sha256 cellar: :any_skip_relocation, ventura:        "14228a9abc8ce3561a5ab882d4c449451efb48c98c6f0e3ee6dd279e047fdf59"
    sha256 cellar: :any_skip_relocation, monterey:       "14228a9abc8ce3561a5ab882d4c449451efb48c98c6f0e3ee6dd279e047fdf59"
    sha256 cellar: :any_skip_relocation, big_sur:        "14228a9abc8ce3561a5ab882d4c449451efb48c98c6f0e3ee6dd279e047fdf59"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c28541d62d98aef40be8154434cc4a195303456129e09e3a559a61bd056a24bd"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/contentful space list 2>&1", 1)
    assert_match "🚨  Error: You have to be logged in to do this.", output
    assert_match "You can log in via contentful login", output
    assert_match "Or provide a management token via --management-token argument", output
  end
end
