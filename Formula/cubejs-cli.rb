require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.31.22.tgz"
  sha256 "a831658b946ba4b5ba9cf6f7ef7dacdc1fee0e11a93d88f8e84cc05df9d3f8f1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "708167eca07d93ca2376587570ae9f41cec1746edd565d4da4c34d76f27adf40"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "708167eca07d93ca2376587570ae9f41cec1746edd565d4da4c34d76f27adf40"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "708167eca07d93ca2376587570ae9f41cec1746edd565d4da4c34d76f27adf40"
    sha256 cellar: :any_skip_relocation, ventura:        "f20f6acbf5280600166c375b28448c3aab056fa648055b62ed5d016d21dcbebf"
    sha256 cellar: :any_skip_relocation, monterey:       "f20f6acbf5280600166c375b28448c3aab056fa648055b62ed5d016d21dcbebf"
    sha256 cellar: :any_skip_relocation, big_sur:        "f20f6acbf5280600166c375b28448c3aab056fa648055b62ed5d016d21dcbebf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "708167eca07d93ca2376587570ae9f41cec1746edd565d4da4c34d76f27adf40"
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
