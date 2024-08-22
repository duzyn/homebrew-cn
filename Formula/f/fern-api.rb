class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.39.14.tgz"
  sha256 "07bc4cb452487bc4fc425fae0156906ee3f7b4b8266ea74ba0b3b3148df47d2a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f03af7af23a471eb17acc7b8ea272c8e1deb8c1c069ce72aba8c352478332b5f"
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
