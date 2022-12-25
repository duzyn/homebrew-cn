require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.56.1.tgz"
  sha256 "3792886106596c3186a30b0a72146bbcd41653de563e11badd5850132faf8ad7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a595eaaad943d948f768e92904b9ec070ef647b2c226fce82004037371ec6696"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a595eaaad943d948f768e92904b9ec070ef647b2c226fce82004037371ec6696"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a595eaaad943d948f768e92904b9ec070ef647b2c226fce82004037371ec6696"
    sha256 cellar: :any_skip_relocation, ventura:        "449c905359b31fd7f16a86f4a4d3d4f7829ac9c380a2d0d954c261f102926d83"
    sha256 cellar: :any_skip_relocation, monterey:       "449c905359b31fd7f16a86f4a4d3d4f7829ac9c380a2d0d954c261f102926d83"
    sha256 cellar: :any_skip_relocation, big_sur:        "449c905359b31fd7f16a86f4a4d3d4f7829ac9c380a2d0d954c261f102926d83"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "346f32996ed60a05249c447434a394f857826e43a473d8e8495ce204f7813353"
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
