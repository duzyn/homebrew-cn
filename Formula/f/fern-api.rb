class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.57.3.tgz"
  sha256 "b03c22397957aef48f6c035560a31161c54848f1263ba18f16dbc98c60c55514"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "894ca030517b19027a22a67694ccebab2d7276b980f71eefd43b74ca6428b42b"
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
