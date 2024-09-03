class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.40.3.tgz"
  sha256 "e500e8f7a1973ccc48fc5fce502e455bfa90039f8ba25536472fdc9779c59e7a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c61470d8543c63ae783d29989709b78e70241771ae73315f9533f3f2d74b9c27"
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
