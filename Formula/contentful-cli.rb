require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.16.20.tgz"
  sha256 "472053941361c3b8145f07457b360b9fa3d48fcd4fa0ac52119a16a205735895"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7c3239dc60e6171739f785f05a0aede0c994726daa19874bf7af8493ee9ebf4e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7c3239dc60e6171739f785f05a0aede0c994726daa19874bf7af8493ee9ebf4e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7c3239dc60e6171739f785f05a0aede0c994726daa19874bf7af8493ee9ebf4e"
    sha256 cellar: :any_skip_relocation, ventura:        "95b366390e2fcf4964f9c08cb9a5d10012cab55b9c3fa753c6cca84c1dfc0321"
    sha256 cellar: :any_skip_relocation, monterey:       "95b366390e2fcf4964f9c08cb9a5d10012cab55b9c3fa753c6cca84c1dfc0321"
    sha256 cellar: :any_skip_relocation, big_sur:        "95b366390e2fcf4964f9c08cb9a5d10012cab55b9c3fa753c6cca84c1dfc0321"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7c3239dc60e6171739f785f05a0aede0c994726daa19874bf7af8493ee9ebf4e"
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
