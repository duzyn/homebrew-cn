require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.31.32.tgz"
  sha256 "980a86bb552c1b74c935880874ab3892df7f79ffcff857ce4ddd3b80eed0eb4f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "64d8156e9ee1dd076afc416707c4bd0b637d0f6b2b02630ef7bfea9e2bd8a5a3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "64d8156e9ee1dd076afc416707c4bd0b637d0f6b2b02630ef7bfea9e2bd8a5a3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "64d8156e9ee1dd076afc416707c4bd0b637d0f6b2b02630ef7bfea9e2bd8a5a3"
    sha256 cellar: :any_skip_relocation, ventura:        "53f309a7d6a702bbb8157b155c14d2dd44e62dfcb4f031aa41064baf8e528186"
    sha256 cellar: :any_skip_relocation, monterey:       "53f309a7d6a702bbb8157b155c14d2dd44e62dfcb4f031aa41064baf8e528186"
    sha256 cellar: :any_skip_relocation, big_sur:        "53f309a7d6a702bbb8157b155c14d2dd44e62dfcb4f031aa41064baf8e528186"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "64d8156e9ee1dd076afc416707c4bd0b637d0f6b2b02630ef7bfea9e2bd8a5a3"
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
