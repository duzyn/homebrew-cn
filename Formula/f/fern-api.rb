class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.43.4.tgz"
  sha256 "593f101328fd6709e6279d2bb0c67e59e99532b2bf906e0193ead86e7130768a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b0673fd0bc300acafe2824da86dd7ba9933b8198ad02bb9b1c4422521ff26faf"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/fern init 2>&1", 1)
    assert_match "Login required", output

    system bin/"fern", "--version"
  end
end
