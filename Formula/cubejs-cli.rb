require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.31.37.tgz"
  sha256 "b4b2c91e87bc6f1961f11e56d5b25aa2cfa5d547c285700b7fe12413cf51bc41"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ed8db2206afb7001540bf0eb52f2c7857b4f480b79a269c69e6f26c7de1155ac"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ed8db2206afb7001540bf0eb52f2c7857b4f480b79a269c69e6f26c7de1155ac"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ed8db2206afb7001540bf0eb52f2c7857b4f480b79a269c69e6f26c7de1155ac"
    sha256 cellar: :any_skip_relocation, ventura:        "74076ee4e3519fbeeff89e589eb4f7ab3dff3b5c5445f2ac90669afb39019eac"
    sha256 cellar: :any_skip_relocation, monterey:       "74076ee4e3519fbeeff89e589eb4f7ab3dff3b5c5445f2ac90669afb39019eac"
    sha256 cellar: :any_skip_relocation, big_sur:        "74076ee4e3519fbeeff89e589eb4f7ab3dff3b5c5445f2ac90669afb39019eac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ed8db2206afb7001540bf0eb52f2c7857b4f480b79a269c69e6f26c7de1155ac"
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
