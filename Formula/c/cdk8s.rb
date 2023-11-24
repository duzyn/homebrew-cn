require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.183.0.tgz"
  sha256 "2da015af38ab36fedf5e202031667cf2dce4757c1b08b5489841ac0304d3a6a7"
  license "Apache-2.0"
  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e33916db919f7436c5831de9160534a7d6b1c07edbdc1bbefad7e492c65089fc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e33916db919f7436c5831de9160534a7d6b1c07edbdc1bbefad7e492c65089fc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e33916db919f7436c5831de9160534a7d6b1c07edbdc1bbefad7e492c65089fc"
    sha256 cellar: :any_skip_relocation, sonoma:         "2063acfcb0d9d08fd36e956904e209078584dea072709f89077e761893f42d43"
    sha256 cellar: :any_skip_relocation, ventura:        "2063acfcb0d9d08fd36e956904e209078584dea072709f89077e761893f42d43"
    sha256 cellar: :any_skip_relocation, monterey:       "2063acfcb0d9d08fd36e956904e209078584dea072709f89077e761893f42d43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e33916db919f7436c5831de9160534a7d6b1c07edbdc1bbefad7e492c65089fc"
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
