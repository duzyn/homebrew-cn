require "language/node"

class SnykCli < Formula
  desc "Scans and monitors projects for security vulnerabilities"
  homepage "https://snyk.io"
  url "https://registry.npmjs.org/snyk/-/snyk-1.1292.2.tgz"
  sha256 "6d12f6451c0ac5e2e1263da6b9a6e6de6366e052fadaca2f82fd070ce7b6b534"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b6cf30c1686fe3d44ee88ff22d0e88c7f801ace13f2e3130920e4298a0d0ffb6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b6cf30c1686fe3d44ee88ff22d0e88c7f801ace13f2e3130920e4298a0d0ffb6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b6cf30c1686fe3d44ee88ff22d0e88c7f801ace13f2e3130920e4298a0d0ffb6"
    sha256 cellar: :any_skip_relocation, sonoma:         "d1488d4558b7b82026a84b1682516af131d92ba532a3189429112c97d14d2155"
    sha256 cellar: :any_skip_relocation, ventura:        "d1488d4558b7b82026a84b1682516af131d92ba532a3189429112c97d14d2155"
    sha256 cellar: :any_skip_relocation, monterey:       "d1488d4558b7b82026a84b1682516af131d92ba532a3189429112c97d14d2155"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0737efcbe65cfbdf2b2cb6f756856d352451f6fd94849783983dd79495bdaff4"
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
