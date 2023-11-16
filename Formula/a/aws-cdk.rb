require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.108.1.tgz"
  sha256 "008da41c7bbf79d828743a599f5762b796a4edbdaa2183d0eeea82ed1926b2a3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "37987ee4c78e301978471f4de867a0e72dbfe13dbca1184afbc5a3d14a26c062"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "37987ee4c78e301978471f4de867a0e72dbfe13dbca1184afbc5a3d14a26c062"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "37987ee4c78e301978471f4de867a0e72dbfe13dbca1184afbc5a3d14a26c062"
    sha256 cellar: :any_skip_relocation, sonoma:         "f0c63f4a8627e97e8449651a4217b43892cb3ff9581a3fae0b0f03e23310d1d2"
    sha256 cellar: :any_skip_relocation, ventura:        "f0c63f4a8627e97e8449651a4217b43892cb3ff9581a3fae0b0f03e23310d1d2"
    sha256 cellar: :any_skip_relocation, monterey:       "f0c63f4a8627e97e8449651a4217b43892cb3ff9581a3fae0b0f03e23310d1d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f92f5fb6a7c535de0189a63d36bf2b667dea33abdbbfa078cc088d3e55d9f7ff"
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
