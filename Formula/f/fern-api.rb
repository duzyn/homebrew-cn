class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.37.4.tgz"
  sha256 "8017d7d730278a1896e9726f400d301bd53b1b9d918a71c93d70b0a39580e0ce"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bbc58bef4447d767fd0ce1742b9cd178eec9c4b514def10973e7ddc1e36624d1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bbc58bef4447d767fd0ce1742b9cd178eec9c4b514def10973e7ddc1e36624d1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bbc58bef4447d767fd0ce1742b9cd178eec9c4b514def10973e7ddc1e36624d1"
    sha256 cellar: :any_skip_relocation, sonoma:         "bbc58bef4447d767fd0ce1742b9cd178eec9c4b514def10973e7ddc1e36624d1"
    sha256 cellar: :any_skip_relocation, ventura:        "bbc58bef4447d767fd0ce1742b9cd178eec9c4b514def10973e7ddc1e36624d1"
    sha256 cellar: :any_skip_relocation, monterey:       "bbc58bef4447d767fd0ce1742b9cd178eec9c4b514def10973e7ddc1e36624d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c92b058939613495d2d11902f491d3125c6540232f7e08173cde3a0fd63b6f9a"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/fern init 2>&1", 1)
    assert_match "Login required", output

    assert_match version.to_s, shell_output("#{bin}/fern --version")
  end
end
