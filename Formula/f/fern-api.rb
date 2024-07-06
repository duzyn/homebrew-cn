require "language/node"

class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.31.15.tgz"
  sha256 "5d8da2c682680228a30b3f6cbc731f8a322460d08b904929c840fecf2ac27e1c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fa739c2271859a48675f452da375186100e97d645cd729845172c6f8537524f9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fa739c2271859a48675f452da375186100e97d645cd729845172c6f8537524f9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fa739c2271859a48675f452da375186100e97d645cd729845172c6f8537524f9"
    sha256 cellar: :any_skip_relocation, sonoma:         "fa739c2271859a48675f452da375186100e97d645cd729845172c6f8537524f9"
    sha256 cellar: :any_skip_relocation, ventura:        "fa739c2271859a48675f452da375186100e97d645cd729845172c6f8537524f9"
    sha256 cellar: :any_skip_relocation, monterey:       "fa739c2271859a48675f452da375186100e97d645cd729845172c6f8537524f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9f5b27a126867cb516ae019324bc764374f1402558b8d6c83b84879880964caa"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/fern init 2>&1", 1)
    assert_match "Login required", output

    assert_match version.to_s, shell_output("#{bin}/fern --version")
  end
end
