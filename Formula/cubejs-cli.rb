require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.31.29.tgz"
  sha256 "23033db39967f9cac2e16090007de064430ae87c629bc0d5b5f6fb4e57c3cf3f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bc0f9f1522316d20b77decb40cada6c0dc20cb3ee2552e5284ad2a6a0d2d4ebc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bc0f9f1522316d20b77decb40cada6c0dc20cb3ee2552e5284ad2a6a0d2d4ebc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bc0f9f1522316d20b77decb40cada6c0dc20cb3ee2552e5284ad2a6a0d2d4ebc"
    sha256 cellar: :any_skip_relocation, ventura:        "9dd3880c2f84bdf8b195ed870afd4e275b64471f0f5a696f6d06eec18316b551"
    sha256 cellar: :any_skip_relocation, monterey:       "9dd3880c2f84bdf8b195ed870afd4e275b64471f0f5a696f6d06eec18316b551"
    sha256 cellar: :any_skip_relocation, big_sur:        "9dd3880c2f84bdf8b195ed870afd4e275b64471f0f5a696f6d06eec18316b551"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bc0f9f1522316d20b77decb40cada6c0dc20cb3ee2552e5284ad2a6a0d2d4ebc"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cubejs --version")
    system "cubejs", "create", "hello-world", "-d", "postgres"
    assert_predicate testpath/"hello-world/schema/Orders.js", :exist?
  end
end
