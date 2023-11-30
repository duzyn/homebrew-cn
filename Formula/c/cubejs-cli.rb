require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.34.27.tgz"
  sha256 "bcc199eeeaed808b7650602b74aa077fbfcdd5eb0a6d7e2d6ab1f302a383ea48"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "f8b8b671c8de7a1f3bbada4d69bc97fa3db0696ac04269df0e8a54d4969d06fe"
    sha256 cellar: :any, arm64_ventura:  "f8b8b671c8de7a1f3bbada4d69bc97fa3db0696ac04269df0e8a54d4969d06fe"
    sha256 cellar: :any, arm64_monterey: "f8b8b671c8de7a1f3bbada4d69bc97fa3db0696ac04269df0e8a54d4969d06fe"
    sha256 cellar: :any, sonoma:         "510bdb8345219a062442a3ae7a21a8dd9aef04d3d312b6101886f55f1e91de44"
    sha256 cellar: :any, ventura:        "510bdb8345219a062442a3ae7a21a8dd9aef04d3d312b6101886f55f1e91de44"
    sha256 cellar: :any, monterey:       "510bdb8345219a062442a3ae7a21a8dd9aef04d3d312b6101886f55f1e91de44"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cubejs --version")
    system bin/"cubejs", "create", "hello-world", "-d", "postgres"
    assert_predicate testpath/"hello-world/model/cubes/orders.yml", :exist?
  end
end
