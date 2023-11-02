require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-3.1.7.tgz"
  sha256 "e953ea9167bec98bdae8f9651ad2e6f3e4685d3e376b6bd4746c8fa2e3641fb2"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bbe79cd1dda6418061b99d1dd71499a7f23a799aaeddb35195dd99f87706581f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bbe79cd1dda6418061b99d1dd71499a7f23a799aaeddb35195dd99f87706581f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bbe79cd1dda6418061b99d1dd71499a7f23a799aaeddb35195dd99f87706581f"
    sha256 cellar: :any_skip_relocation, sonoma:         "c9e978b2ca1edcfba080555cc834370323ac4208813830df0f821ca22926c68f"
    sha256 cellar: :any_skip_relocation, ventura:        "c9e978b2ca1edcfba080555cc834370323ac4208813830df0f821ca22926c68f"
    sha256 cellar: :any_skip_relocation, monterey:       "c9e978b2ca1edcfba080555cc834370323ac4208813830df0f821ca22926c68f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bbe79cd1dda6418061b99d1dd71499a7f23a799aaeddb35195dd99f87706581f"
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
