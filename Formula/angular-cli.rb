require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-15.0.4.tgz"
  sha256 "1e01b4f55486c30580dc11f4a7ed3f4e8688ca2cd50ae6fdc36cdc481234b9c4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cdd4f923a0bf8562530311d49657851c31721fa4b4fb360e809389db7437d98f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cdd4f923a0bf8562530311d49657851c31721fa4b4fb360e809389db7437d98f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cdd4f923a0bf8562530311d49657851c31721fa4b4fb360e809389db7437d98f"
    sha256 cellar: :any_skip_relocation, ventura:        "37c8828b75c62040c5002dd066566831b89eb8273ce5d2ce2cc83de882ce648d"
    sha256 cellar: :any_skip_relocation, monterey:       "37c8828b75c62040c5002dd066566831b89eb8273ce5d2ce2cc83de882ce648d"
    sha256 cellar: :any_skip_relocation, big_sur:        "37c8828b75c62040c5002dd066566831b89eb8273ce5d2ce2cc83de882ce648d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cdd4f923a0bf8562530311d49657851c31721fa4b4fb360e809389db7437d98f"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"ng", "new", "angular-homebrew-test", "--skip-install"
    assert_predicate testpath/"angular-homebrew-test/package.json", :exist?, "Project was not created"
  end
end
