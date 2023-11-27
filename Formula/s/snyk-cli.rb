require "language/node"

class SnykCli < Formula
  desc "Scans and monitors projects for security vulnerabilities"
  homepage "https://snyk.io"
  url "https://registry.npmjs.org/snyk/-/snyk-1.1254.0.tgz"
  sha256 "ae13d60d6ec586d7c640c0aa2dae16a4da2f0ae25ff9ab176462c60544dbeb6f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a8733b100df0cdf3bd801f2da55dcf9db958af68801a77c255bae88c9385d8b8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "195b628176f8f350680f1ed6781ed2d84c4c3f292f75929fae92afe5848dc13b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "583435cdae230a286b48479719c8606efeaaf2b517b936ea69240caeca8ad25e"
    sha256 cellar: :any_skip_relocation, sonoma:         "270483fe994cce3448830a29a048e31639a754e5978ea77a3f709f077ec2db18"
    sha256 cellar: :any_skip_relocation, ventura:        "dffadbbc3d9c43af7001e311db216014d67482a545fdfbd979ca238f90aac7d6"
    sha256 cellar: :any_skip_relocation, monterey:       "236db01f102c0c57fdc3edd515cdf6a6f0de3eb3f7ba882e29245ea8c43d4466"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "71a449eb3259f22f54f016ea6315f9df40e98b8317221a956ee8473effc29e47"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/snyk version")

    output = shell_output("#{bin}/snyk auth homebrew", 2)
    assert_match "Authentication failed. Please check the API token on https://snyk.io", output
  end
end
