require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.58.0.tgz"
  sha256 "6fa59c41fd56c84ee3a9bb1d0b749206064924e71d390aab26645eaf71823bdb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "85c48c75d347c19902c1178c922df5e398c20963bc1671d2bbb9373b496d0a24"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "85c48c75d347c19902c1178c922df5e398c20963bc1671d2bbb9373b496d0a24"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "85c48c75d347c19902c1178c922df5e398c20963bc1671d2bbb9373b496d0a24"
    sha256 cellar: :any_skip_relocation, ventura:        "4c5779f5bd13704e07730b3f3b8ea44e9bc5e3d36753a0ce408897f556a52f86"
    sha256 cellar: :any_skip_relocation, monterey:       "4c5779f5bd13704e07730b3f3b8ea44e9bc5e3d36753a0ce408897f556a52f86"
    sha256 cellar: :any_skip_relocation, big_sur:        "4c5779f5bd13704e07730b3f3b8ea44e9bc5e3d36753a0ce408897f556a52f86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3e6da1d95fa7f7449cca2fb0ef9d9af274cc5ed89ccf478bf7e55d14be796c0e"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Replace universal binaries with native slices.
    deuniversalize_machos
  end

  test do
    # `cdk init` cannot be run in a non-empty directory
    mkdir "testapp" do
      shell_output("#{bin}/cdk init app --language=javascript")
      list = shell_output("#{bin}/cdk list")
      cdkversion = shell_output("#{bin}/cdk --version")
      assert_match "TestappStack", list
      assert_match version.to_s, cdkversion
    end
  end
end
