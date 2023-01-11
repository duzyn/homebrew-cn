require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-0.27.2.tgz"
  sha256 "6189b81370858840d4478658a5fea70cb44b70817efdc9deac8fd5354135985f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "15d20607f9255adf0ebe7fd9ab60a0523de1536c4be39cc40480f89977b4f352"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "15d20607f9255adf0ebe7fd9ab60a0523de1536c4be39cc40480f89977b4f352"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "15d20607f9255adf0ebe7fd9ab60a0523de1536c4be39cc40480f89977b4f352"
    sha256 cellar: :any_skip_relocation, ventura:        "b7d64ece17c50c08932b1b13d68bc5022591ae78e4d78bc57d5d5f97d3838dcb"
    sha256 cellar: :any_skip_relocation, monterey:       "b7d64ece17c50c08932b1b13d68bc5022591ae78e4d78bc57d5d5f97d3838dcb"
    sha256 cellar: :any_skip_relocation, big_sur:        "b7d64ece17c50c08932b1b13d68bc5022591ae78e4d78bc57d5d5f97d3838dcb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7134edb1e82919d8971292f0ef72da048a4c393e81becb880a48523271f5aca6"
  end

  depends_on "node"

  def install
    # Call rm -f instead of rimraf, because devDeps aren't present in Homebrew at postpack time
    inreplace "package.json", "rimraf oclif.manifest.json", "rm -f oclif.manifest.json"
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
    # Replace universal binaries with their native slices
    deuniversalize_machos
  end

  test do
    system bin/"asyncapi", "new", "--file-name=asyncapi.yml", "--example=default-example.yaml", "--no-tty"
    assert_predicate testpath/"asyncapi.yml", :exist?, "AsyncAPI file was not created"
  end
end
