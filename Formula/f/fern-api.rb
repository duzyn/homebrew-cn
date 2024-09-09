class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.41.7.tgz"
  sha256 "00a293c45e1a9630241808e1ba605b838ddf99c00bece0b970c0338a8c9f4630"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7635fc588f2713f102bb088fe204e891fb39bb506d0a6bd655e89a9b20182530"
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
