class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.39.4.tgz"
  sha256 "aac76b85770658fdd6dd7090801e907358a936a8364aff66553bd4e434bec351"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3aa98c9823d248aab6338fe07c0745ae264b89c3b2685411320d3566e14bf007"
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
