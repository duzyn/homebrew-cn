class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.37.14.tgz"
  sha256 "334e4081902302801ce052854fb0fe754ba4a60abf0fd4e60065336d2354aa40"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9a3ca990df7f7e15daca03fa52560ac0bf43048dba4e017b99ddb7c0dc9e885d"
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
