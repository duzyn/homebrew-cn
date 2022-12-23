require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.31.30.tgz"
  sha256 "82b776d809ae7dc37e76659681c2973d72e9b19616ec3bd72f5d45eb06bf6e3e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a1db9402145266d5cb1b93e64b46f7260c63863ba8e66360b382799633fb6533"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a1db9402145266d5cb1b93e64b46f7260c63863ba8e66360b382799633fb6533"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a1db9402145266d5cb1b93e64b46f7260c63863ba8e66360b382799633fb6533"
    sha256 cellar: :any_skip_relocation, ventura:        "edbeb31395ba5126b01558bf5f041e10061cc896847fd51befbfbea1a75bfa0d"
    sha256 cellar: :any_skip_relocation, monterey:       "edbeb31395ba5126b01558bf5f041e10061cc896847fd51befbfbea1a75bfa0d"
    sha256 cellar: :any_skip_relocation, big_sur:        "edbeb31395ba5126b01558bf5f041e10061cc896847fd51befbfbea1a75bfa0d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a1db9402145266d5cb1b93e64b46f7260c63863ba8e66360b382799633fb6533"
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
