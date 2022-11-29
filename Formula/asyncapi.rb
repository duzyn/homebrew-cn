require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-0.26.3.tgz"
  sha256 "8a587ffce322e398824abd4fe663e20596d802ca2d0ba7843c17bbd9df540b06"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c54530e88dc23b384cf8680aa05c116ebfdaf5142b0dbd0964ccdf6b2a2b1bf0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "347898f5c849ef5fb0d109eb23b975843bc3bd9bdcc01770fd5d0e158ed406de"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "347898f5c849ef5fb0d109eb23b975843bc3bd9bdcc01770fd5d0e158ed406de"
    sha256 cellar: :any_skip_relocation, ventura:        "e4c2bdcfe78821c52171fbff49172ddfef7c2e1cae87c974ab8ead4a528da333"
    sha256 cellar: :any_skip_relocation, monterey:       "ff28b5d3faf456fede94c30ef451c451981ceb2aa4d22f6f3609e1f0677031d5"
    sha256 cellar: :any_skip_relocation, big_sur:        "ff28b5d3faf456fede94c30ef451c451981ceb2aa4d22f6f3609e1f0677031d5"
    sha256 cellar: :any_skip_relocation, catalina:       "ff28b5d3faf456fede94c30ef451c451981ceb2aa4d22f6f3609e1f0677031d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "33ec1bedbf4bf0200d63005fefddc4b51628c965620cde43ebfce89aac7c2c8e"
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
