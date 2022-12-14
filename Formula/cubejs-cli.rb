require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.31.26.tgz"
  sha256 "155faa0ded557d1c1fb71b564d83e0add239bade1897752468b03ba1eef97efe"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0b9008c557b8307555e8a9d9680b917654d3dadcfa4f0f9136177a06ef4cb0bf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0b9008c557b8307555e8a9d9680b917654d3dadcfa4f0f9136177a06ef4cb0bf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0b9008c557b8307555e8a9d9680b917654d3dadcfa4f0f9136177a06ef4cb0bf"
    sha256 cellar: :any_skip_relocation, ventura:        "e402e0bf34ccd34941e3c472e7a43b7afc267df733b7d04f4569f2a9f39e4e79"
    sha256 cellar: :any_skip_relocation, monterey:       "e402e0bf34ccd34941e3c472e7a43b7afc267df733b7d04f4569f2a9f39e4e79"
    sha256 cellar: :any_skip_relocation, big_sur:        "e402e0bf34ccd34941e3c472e7a43b7afc267df733b7d04f4569f2a9f39e4e79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0b9008c557b8307555e8a9d9680b917654d3dadcfa4f0f9136177a06ef4cb0bf"
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
