require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.57.0.tgz"
  sha256 "0625162cfeade7259951de15b0b81e88f2f60a2fd5ecda972412bad48c2abb3d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "99caf786f02c4f078e91001b306ced75241aa1373c934752eba8ef97b13d00c7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "99caf786f02c4f078e91001b306ced75241aa1373c934752eba8ef97b13d00c7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "99caf786f02c4f078e91001b306ced75241aa1373c934752eba8ef97b13d00c7"
    sha256 cellar: :any_skip_relocation, ventura:        "9d0d720c894dab66452d5bf573a66e760669adf2a0dec365a8706fae21a238e8"
    sha256 cellar: :any_skip_relocation, monterey:       "9d0d720c894dab66452d5bf573a66e760669adf2a0dec365a8706fae21a238e8"
    sha256 cellar: :any_skip_relocation, big_sur:        "9d0d720c894dab66452d5bf573a66e760669adf2a0dec365a8706fae21a238e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7b179760bfa570413d38ff8830820aa35cb26e003c2a5f774f50dc11d96930e2"
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
