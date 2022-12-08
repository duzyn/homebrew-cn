require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.54.0.tgz"
  sha256 "e9fdc2954543fadb88aa18d0ef0a3007f1ab33fc691111aec7bb11f78f0cf9a6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c41f3c5a95e9ad66c6c09cb2cd18c89989ca35096bbcf274f3cea6ec4e8f0365"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c41f3c5a95e9ad66c6c09cb2cd18c89989ca35096bbcf274f3cea6ec4e8f0365"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c41f3c5a95e9ad66c6c09cb2cd18c89989ca35096bbcf274f3cea6ec4e8f0365"
    sha256 cellar: :any_skip_relocation, ventura:        "c7f461f71e35515207ede16a84fa858399271a9c50b7919ae8d1c1ef69607500"
    sha256 cellar: :any_skip_relocation, monterey:       "c7f461f71e35515207ede16a84fa858399271a9c50b7919ae8d1c1ef69607500"
    sha256 cellar: :any_skip_relocation, big_sur:        "c7f461f71e35515207ede16a84fa858399271a9c50b7919ae8d1c1ef69607500"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ab6aeeb6bfcd7e09b9c422f8f50eeeeb92a91c6dc1e021734d0937ab3e9dfdec"
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
