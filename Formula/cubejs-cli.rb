require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.31.21.tgz"
  sha256 "fd3d40d4f13bfddfe6fc1bdad885e419157a8a24e16c5dda995152b721fbb981"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1dc0713daf75cadbea7a8f0eeca3f6846f7a729f00d4578b15a5a5e16daa4d6a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1dc0713daf75cadbea7a8f0eeca3f6846f7a729f00d4578b15a5a5e16daa4d6a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1dc0713daf75cadbea7a8f0eeca3f6846f7a729f00d4578b15a5a5e16daa4d6a"
    sha256 cellar: :any_skip_relocation, ventura:        "cf9eabcd17200d6aebc62106436121cc1753299ced20318daae0ee6d434d6bc4"
    sha256 cellar: :any_skip_relocation, monterey:       "cf9eabcd17200d6aebc62106436121cc1753299ced20318daae0ee6d434d6bc4"
    sha256 cellar: :any_skip_relocation, big_sur:        "cf9eabcd17200d6aebc62106436121cc1753299ced20318daae0ee6d434d6bc4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1dc0713daf75cadbea7a8f0eeca3f6846f7a729f00d4578b15a5a5e16daa4d6a"
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
