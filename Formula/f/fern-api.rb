class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.51.21.tgz"
  sha256 "e7fb649db0ed84b9729d8814bfcbd561cc0a02d93b801882b22678c67146022d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8298886251fbb069db3b019346d10a454cb86cecdd1b5e3264d86a427fbd54c2"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"fern", "init", "--docs", "--org", "brewtest"
    assert_path_exists testpath/"fern/docs.yml"
    assert_match "\"organization\": \"brewtest\"", (testpath/"fern/fern.config.json").read

    system bin/"fern", "--version"
  end
end
