require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.31.27.tgz"
  sha256 "850cbaf5a1c2fbd69c5f1027e84a8225638c3428598a413d397e4e7ae5317ee1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "19b355797cebcb72e1412ec817ad8519583f01643864a176619aab8500714d98"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "19b355797cebcb72e1412ec817ad8519583f01643864a176619aab8500714d98"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "19b355797cebcb72e1412ec817ad8519583f01643864a176619aab8500714d98"
    sha256 cellar: :any_skip_relocation, ventura:        "0b51650d6ec2728b19facf2263075fb2f3e74a401b8cb6084d83ea6e7a287924"
    sha256 cellar: :any_skip_relocation, monterey:       "0b51650d6ec2728b19facf2263075fb2f3e74a401b8cb6084d83ea6e7a287924"
    sha256 cellar: :any_skip_relocation, big_sur:        "0b51650d6ec2728b19facf2263075fb2f3e74a401b8cb6084d83ea6e7a287924"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "19b355797cebcb72e1412ec817ad8519583f01643864a176619aab8500714d98"
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
