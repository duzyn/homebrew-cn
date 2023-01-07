require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.18.0.tgz"
  sha256 "13289eb453e65b7b216a63fd4032a75e9ad904599036739725b4726494f501cf"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a50cee1ca7e98948ae364eaf313b1b08c41276e05504ad191267219264774e7d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a50cee1ca7e98948ae364eaf313b1b08c41276e05504ad191267219264774e7d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a50cee1ca7e98948ae364eaf313b1b08c41276e05504ad191267219264774e7d"
    sha256 cellar: :any_skip_relocation, ventura:        "2e88f29d34ec2550f98093b77d5062fee107af55cca6d49b547387d4aad80547"
    sha256 cellar: :any_skip_relocation, monterey:       "2e88f29d34ec2550f98093b77d5062fee107af55cca6d49b547387d4aad80547"
    sha256 cellar: :any_skip_relocation, big_sur:        "2e88f29d34ec2550f98093b77d5062fee107af55cca6d49b547387d4aad80547"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a50cee1ca7e98948ae364eaf313b1b08c41276e05504ad191267219264774e7d"
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
