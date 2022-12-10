require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.31.23.tgz"
  sha256 "cc908e2621eac403e3c4ee637604797163b955235e4e7e99f4915bef9a3df5a6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1ffc8332a94e58dc15ed0d4b3eee294129c24eac2fbee900f3041c569de85ca9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1ffc8332a94e58dc15ed0d4b3eee294129c24eac2fbee900f3041c569de85ca9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1ffc8332a94e58dc15ed0d4b3eee294129c24eac2fbee900f3041c569de85ca9"
    sha256 cellar: :any_skip_relocation, ventura:        "500ee7844cad093e64f595f84e088bc6d8ec2ddaba6028a3a40aa252d92b9cfc"
    sha256 cellar: :any_skip_relocation, monterey:       "500ee7844cad093e64f595f84e088bc6d8ec2ddaba6028a3a40aa252d92b9cfc"
    sha256 cellar: :any_skip_relocation, big_sur:        "500ee7844cad093e64f595f84e088bc6d8ec2ddaba6028a3a40aa252d92b9cfc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1ffc8332a94e58dc15ed0d4b3eee294129c24eac2fbee900f3041c569de85ca9"
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
