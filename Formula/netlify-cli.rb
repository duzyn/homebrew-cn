require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-12.7.0.tgz"
  sha256 "efca89076a4697a95cda3de4a33a796382653e3af1007b84541e93aad50a6e3f"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "838ea4c6fc2fdd42d71b5363d5c101a973ddb1565b9c58d0d3d74f04c246e1c4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "838ea4c6fc2fdd42d71b5363d5c101a973ddb1565b9c58d0d3d74f04c246e1c4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "838ea4c6fc2fdd42d71b5363d5c101a973ddb1565b9c58d0d3d74f04c246e1c4"
    sha256 cellar: :any_skip_relocation, ventura:        "e28f8aa8f072330bcd6af431237c049a7d87e71e25c4b4d154a659605eaf66a7"
    sha256 cellar: :any_skip_relocation, monterey:       "e28f8aa8f072330bcd6af431237c049a7d87e71e25c4b4d154a659605eaf66a7"
    sha256 cellar: :any_skip_relocation, big_sur:        "e28f8aa8f072330bcd6af431237c049a7d87e71e25c4b4d154a659605eaf66a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "93cdfc1a2188bcf0d4aa554e910b7cd4f86f5f08f1466b6edbd23579ec71290d"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "Not logged in. Please log in to see site status.", shell_output("#{bin}/netlify status")
  end
end
