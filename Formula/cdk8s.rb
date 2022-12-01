require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.1.62.tgz"
  sha256 "f4d30d02339170a8cd7c8dc9451d4dd9a04e272c8fab75e4fecafc0bb40c5761"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2b0f2304d5e545270e217f5a15820202ac06b51f108fff8c88e159804c02cc02"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3db18a22c65565ebfd024721d708eac24d5236eeaff579155bdb55a9886bf3ab"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3db18a22c65565ebfd024721d708eac24d5236eeaff579155bdb55a9886bf3ab"
    sha256 cellar: :any_skip_relocation, monterey:       "2b0f2304d5e545270e217f5a15820202ac06b51f108fff8c88e159804c02cc02"
    sha256 cellar: :any_skip_relocation, big_sur:        "2b0f2304d5e545270e217f5a15820202ac06b51f108fff8c88e159804c02cc02"
    sha256 cellar: :any_skip_relocation, catalina:       "2b0f2304d5e545270e217f5a15820202ac06b51f108fff8c88e159804c02cc02"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3db18a22c65565ebfd024721d708eac24d5236eeaff579155bdb55a9886bf3ab"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "Cannot initialize a project in a non-empty directory",
      shell_output("#{bin}/cdk8s init python-app 2>&1", 1)
  end
end
