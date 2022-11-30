require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-0.26.4.tgz"
  sha256 "493e77a1d1ec2e93f4b8b4efa38e9961590240baca5b2b28c2f22ba31aad0442"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "48030f903ca4aaa8b4a6d62472fb1ece9b7156cd8ddfbfe566ea0caf2d682677"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "48030f903ca4aaa8b4a6d62472fb1ece9b7156cd8ddfbfe566ea0caf2d682677"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "48030f903ca4aaa8b4a6d62472fb1ece9b7156cd8ddfbfe566ea0caf2d682677"
    sha256 cellar: :any_skip_relocation, ventura:        "0b2fd9000f035d66e40e567d3249f11f61379f582ad94dfcb8ea186ad1049bb7"
    sha256 cellar: :any_skip_relocation, monterey:       "7bdf442cc8eecc73da27b8e119271aaee47012fb827f62c6d6717fdc1c254456"
    sha256 cellar: :any_skip_relocation, big_sur:        "7bdf442cc8eecc73da27b8e119271aaee47012fb827f62c6d6717fdc1c254456"
    sha256 cellar: :any_skip_relocation, catalina:       "7bdf442cc8eecc73da27b8e119271aaee47012fb827f62c6d6717fdc1c254456"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c9055b34b3f6335f7e746dd8e4d3475bdd39cb2a89f70538df7caf25678ac24c"
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
