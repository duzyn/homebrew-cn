require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.112.0.tgz"
  sha256 "3113af134f75ef28ee3ff18db295bfb9b367f1f6594283e619d523c19d60a0d8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3e1b85d723dab8fc42f17a5e28ce9a9a3fd0a73ed0aa56336613d77b0f955be4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3e1b85d723dab8fc42f17a5e28ce9a9a3fd0a73ed0aa56336613d77b0f955be4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3e1b85d723dab8fc42f17a5e28ce9a9a3fd0a73ed0aa56336613d77b0f955be4"
    sha256 cellar: :any_skip_relocation, sonoma:         "bf2334e85348139d3f0510f9cad7e87078c33915f917e0a6948490a5c777181e"
    sha256 cellar: :any_skip_relocation, ventura:        "bf2334e85348139d3f0510f9cad7e87078c33915f917e0a6948490a5c777181e"
    sha256 cellar: :any_skip_relocation, monterey:       "bf2334e85348139d3f0510f9cad7e87078c33915f917e0a6948490a5c777181e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "780c21e75f53803258d175ef4482c54b4f39a6c37f0159245b24925deab7abf0"
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
