class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.200.143.tgz"
  sha256 "06f8ae3cbec897c1233133b2293834212b6d2bb2c95b90733f6fb582e1dcb094"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f67f415390b77c0cc394abcd4e4e9b47541a4083161c4bde9b5c60cf62b05783"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f67f415390b77c0cc394abcd4e4e9b47541a4083161c4bde9b5c60cf62b05783"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f67f415390b77c0cc394abcd4e4e9b47541a4083161c4bde9b5c60cf62b05783"
    sha256 cellar: :any_skip_relocation, sonoma:        "ef310c690d3f6caa3a15b608f49fac326f12b3eb3ae35be59f44dc43c60b483d"
    sha256 cellar: :any_skip_relocation, ventura:       "ef310c690d3f6caa3a15b608f49fac326f12b3eb3ae35be59f44dc43c60b483d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f67f415390b77c0cc394abcd4e4e9b47541a4083161c4bde9b5c60cf62b05783"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f67f415390b77c0cc394abcd4e4e9b47541a4083161c4bde9b5c60cf62b05783"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/cdk8s init python-app 2>&1", 1)
    assert_match "Initializing a project from the python-app template", output
  end
end
