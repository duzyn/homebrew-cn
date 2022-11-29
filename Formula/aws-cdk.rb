require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.52.0.tgz"
  sha256 "e2201f30e34db178145670d3fd9f9175211c0e7f6ade43bcafddedf7330d0665"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "40fbd3130fe88feb391a49c83aa4bfc60792a38b3a0d180b564829ea9b960737"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "40fbd3130fe88feb391a49c83aa4bfc60792a38b3a0d180b564829ea9b960737"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "40fbd3130fe88feb391a49c83aa4bfc60792a38b3a0d180b564829ea9b960737"
    sha256 cellar: :any_skip_relocation, ventura:        "06ab2f09435fd0ea081f8dcacb1671888a050fe871dfdf36bfda4bac5ef83098"
    sha256 cellar: :any_skip_relocation, monterey:       "06ab2f09435fd0ea081f8dcacb1671888a050fe871dfdf36bfda4bac5ef83098"
    sha256 cellar: :any_skip_relocation, big_sur:        "06ab2f09435fd0ea081f8dcacb1671888a050fe871dfdf36bfda4bac5ef83098"
    sha256 cellar: :any_skip_relocation, catalina:       "06ab2f09435fd0ea081f8dcacb1671888a050fe871dfdf36bfda4bac5ef83098"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dfc4b22041155f7628017ff8127686e1820e2289a599102226870f3fef7a5463"
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
