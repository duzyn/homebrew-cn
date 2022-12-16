require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.55.0.tgz"
  sha256 "14d7f15a516ccd947eabff97f540a30412224a9d8b5ea9d4306835cf7319c40f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "83ff10465f45060bc64c5452dc4bd94d6e227e58407aaf2ca1a3b1f52908dd03"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "83ff10465f45060bc64c5452dc4bd94d6e227e58407aaf2ca1a3b1f52908dd03"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "83ff10465f45060bc64c5452dc4bd94d6e227e58407aaf2ca1a3b1f52908dd03"
    sha256 cellar: :any_skip_relocation, ventura:        "df112588749509107e0a45eaa1dacd840448125d53759b438047168a7e60a5c3"
    sha256 cellar: :any_skip_relocation, monterey:       "df112588749509107e0a45eaa1dacd840448125d53759b438047168a7e60a5c3"
    sha256 cellar: :any_skip_relocation, big_sur:        "df112588749509107e0a45eaa1dacd840448125d53759b438047168a7e60a5c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "335a1af5d9b6f5f4379c6ef8efc8e69437cb1fc69281b0cd845f364c5de38f5d"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Replace universal binaries with native slices.
    deuniversalize_machos
  end

  test do
    # `cdk init` cannot be run in a non-empty directory
    mkdir "testapp" do
      shell_output("#{bin}/cdk init app --language=javascript")
      list = shell_output("#{bin}/cdk list")
      cdkversion = shell_output("#{bin}/cdk --version")
      assert_match "TestappStack", list
      assert_match version.to_s, cdkversion
    end
  end
end
