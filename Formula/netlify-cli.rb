require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-12.4.0.tgz"
  sha256 "e2b1c30d270e48b3aa0038f885d0d1e557728f5334692d68c6221ea9a1bc044a"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7f9e328189c5f6cbf85b1f007331e05d7f2c46d8b814d91ea3d50d7098b30c5a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7f9e328189c5f6cbf85b1f007331e05d7f2c46d8b814d91ea3d50d7098b30c5a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7f9e328189c5f6cbf85b1f007331e05d7f2c46d8b814d91ea3d50d7098b30c5a"
    sha256 cellar: :any_skip_relocation, ventura:        "e8b626b7cc007500c8368a0088df17292ce9a0f51ca46c41e133e70fb4ec8a14"
    sha256 cellar: :any_skip_relocation, monterey:       "e8b626b7cc007500c8368a0088df17292ce9a0f51ca46c41e133e70fb4ec8a14"
    sha256 cellar: :any_skip_relocation, big_sur:        "e8b626b7cc007500c8368a0088df17292ce9a0f51ca46c41e133e70fb4ec8a14"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1a4d4b712243d34e9224578bacf713b119d0954c4d522709a56456a055fd06e9"
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
