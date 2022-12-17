require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.55.1.tgz"
  sha256 "d69e052a8c5f9ab39f02b05ea2f2fd3a0f36644aeb5b6e584e532711216f62fd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e0693b64786548308e145180868eb7974759d81bfafae743df1852dc5ada9104"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e0693b64786548308e145180868eb7974759d81bfafae743df1852dc5ada9104"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e0693b64786548308e145180868eb7974759d81bfafae743df1852dc5ada9104"
    sha256 cellar: :any_skip_relocation, ventura:        "61452697da9a740adc61d420250762bcf38ec13adb55b86f614e9c3d38902dce"
    sha256 cellar: :any_skip_relocation, monterey:       "61452697da9a740adc61d420250762bcf38ec13adb55b86f614e9c3d38902dce"
    sha256 cellar: :any_skip_relocation, big_sur:        "61452697da9a740adc61d420250762bcf38ec13adb55b86f614e9c3d38902dce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e7761016114c6cafddef9e15756782c1489f6eb82058b42541d84253463041b9"
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
