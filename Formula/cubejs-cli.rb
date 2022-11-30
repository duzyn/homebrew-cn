require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.31.18.tgz"
  sha256 "cd7f784ac20ee9ae15a1b7e2d3099a75c76bc242dae3f5a7e3d3dc2b160e15da"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "93b544ded1c1fe6ec3d7ca50c558d2cbf3bab997141cec3cf4141c359fe67555"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "93b544ded1c1fe6ec3d7ca50c558d2cbf3bab997141cec3cf4141c359fe67555"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "93b544ded1c1fe6ec3d7ca50c558d2cbf3bab997141cec3cf4141c359fe67555"
    sha256 cellar: :any_skip_relocation, monterey:       "195a56373eb41f2afea4b22b5cad65db7a4c408cf15782a9311e7b75422b6060"
    sha256 cellar: :any_skip_relocation, big_sur:        "195a56373eb41f2afea4b22b5cad65db7a4c408cf15782a9311e7b75422b6060"
    sha256 cellar: :any_skip_relocation, catalina:       "195a56373eb41f2afea4b22b5cad65db7a4c408cf15782a9311e7b75422b6060"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "93b544ded1c1fe6ec3d7ca50c558d2cbf3bab997141cec3cf4141c359fe67555"
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
