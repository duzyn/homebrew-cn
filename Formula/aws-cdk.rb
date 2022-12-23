require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.56.0.tgz"
  sha256 "819471e4987a68230f98cf74cd684a78cb3a47c9b7773e84030c0a9663a91e9e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a4f841ad24980f51ac8eae352ec4e69c267d51505b6f718506a2c52190773b39"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a4f841ad24980f51ac8eae352ec4e69c267d51505b6f718506a2c52190773b39"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a4f841ad24980f51ac8eae352ec4e69c267d51505b6f718506a2c52190773b39"
    sha256 cellar: :any_skip_relocation, ventura:        "eddbb8fd2347c2b640ec67b48e3680dbfb9ccb99602cf16c39f885b9d77d2f65"
    sha256 cellar: :any_skip_relocation, monterey:       "eddbb8fd2347c2b640ec67b48e3680dbfb9ccb99602cf16c39f885b9d77d2f65"
    sha256 cellar: :any_skip_relocation, big_sur:        "eddbb8fd2347c2b640ec67b48e3680dbfb9ccb99602cf16c39f885b9d77d2f65"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6510a59a8a337c5b17099c3649917ca68916d98c66e3950baf18b91232149158"
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
