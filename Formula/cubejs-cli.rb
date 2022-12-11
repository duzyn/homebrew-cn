require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.31.24.tgz"
  sha256 "2a296a6a0de214a78c2cd27953e5e5df0ec336e1ca67b4267674a610b1f58dd5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b1644b7669f132fb134936d515fe620fa8b7bea3f46a8e438683bbf69d3dcd66"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b1644b7669f132fb134936d515fe620fa8b7bea3f46a8e438683bbf69d3dcd66"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b1644b7669f132fb134936d515fe620fa8b7bea3f46a8e438683bbf69d3dcd66"
    sha256 cellar: :any_skip_relocation, ventura:        "731dc14e9d192310b88f41852b626617abfc5f2e903110a5ac8a4d5fc978189a"
    sha256 cellar: :any_skip_relocation, monterey:       "731dc14e9d192310b88f41852b626617abfc5f2e903110a5ac8a4d5fc978189a"
    sha256 cellar: :any_skip_relocation, big_sur:        "731dc14e9d192310b88f41852b626617abfc5f2e903110a5ac8a4d5fc978189a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b1644b7669f132fb134936d515fe620fa8b7bea3f46a8e438683bbf69d3dcd66"
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
