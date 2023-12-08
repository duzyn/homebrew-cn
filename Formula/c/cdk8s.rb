require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.4.tgz"
  sha256 "4980fb1fab6b3671fc9a4d0bfeab581fce58856921a46cfe16314cfd1b0f34d2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8628cbb3010b195239a34cf0c6d4a5af0c40cb819d2696f7744d4b61b1f4422e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8628cbb3010b195239a34cf0c6d4a5af0c40cb819d2696f7744d4b61b1f4422e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8628cbb3010b195239a34cf0c6d4a5af0c40cb819d2696f7744d4b61b1f4422e"
    sha256 cellar: :any_skip_relocation, sonoma:         "5242bbb904fdb42e066c6f06161524f0c545b3e60381fc75c818d7fc1e20de82"
    sha256 cellar: :any_skip_relocation, ventura:        "5242bbb904fdb42e066c6f06161524f0c545b3e60381fc75c818d7fc1e20de82"
    sha256 cellar: :any_skip_relocation, monterey:       "5242bbb904fdb42e066c6f06161524f0c545b3e60381fc75c818d7fc1e20de82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8628cbb3010b195239a34cf0c6d4a5af0c40cb819d2696f7744d4b61b1f4422e"
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
