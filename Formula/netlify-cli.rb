require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-12.2.10.tgz"
  sha256 "49e42be72329099790418249aa89eabc0dc70d7fff106fa2984d361573688447"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3325f4fe87cfd29b08d97d9507f8c0b24d83050dda95a636b48ebe4fa38e2b2e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3325f4fe87cfd29b08d97d9507f8c0b24d83050dda95a636b48ebe4fa38e2b2e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3325f4fe87cfd29b08d97d9507f8c0b24d83050dda95a636b48ebe4fa38e2b2e"
    sha256 cellar: :any_skip_relocation, ventura:        "8f9c6a5354373c2a553ba290b66a54a857dac4c6ac78aeba23ec99fa8da8369a"
    sha256 cellar: :any_skip_relocation, monterey:       "8f9c6a5354373c2a553ba290b66a54a857dac4c6ac78aeba23ec99fa8da8369a"
    sha256 cellar: :any_skip_relocation, big_sur:        "8f9c6a5354373c2a553ba290b66a54a857dac4c6ac78aeba23ec99fa8da8369a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "76b4babde12c3346e2c501bd99e485a762fa204a5436447f509c7fdcb51bd7d5"
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
