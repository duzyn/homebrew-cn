require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-12.5.0.tgz"
  sha256 "0103df67310ac06b4fa0cb3c365e757624c664fb3a8b85e95346d197f3faaa6b"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "47827ebc1c74e331ea979f84f4137056b4b5a9f8de8669f30a5fddd87a9cdb5a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "47827ebc1c74e331ea979f84f4137056b4b5a9f8de8669f30a5fddd87a9cdb5a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "47827ebc1c74e331ea979f84f4137056b4b5a9f8de8669f30a5fddd87a9cdb5a"
    sha256 cellar: :any_skip_relocation, ventura:        "d7ade6dbdc120ad8c53da38eea3a2c4d356413ab19f9dd44ba2df099cdf6eb13"
    sha256 cellar: :any_skip_relocation, monterey:       "d7ade6dbdc120ad8c53da38eea3a2c4d356413ab19f9dd44ba2df099cdf6eb13"
    sha256 cellar: :any_skip_relocation, big_sur:        "d7ade6dbdc120ad8c53da38eea3a2c4d356413ab19f9dd44ba2df099cdf6eb13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7ee29667a3f2c7b7b7d799221c4c88adcbf9991ab6cb63346f8873bce940a283"
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
