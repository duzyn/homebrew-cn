require "language/node"

class SnykCli < Formula
  desc "Scans and monitors projects for security vulnerabilities"
  homepage "https://snyk.io"
  url "https://registry.npmjs.org/snyk/-/snyk-1.1256.0.tgz"
  sha256 "17fd0f93eed9e64a3d4fcc3b9a249e580a0b7447ce94edc2b80d3fe10a16d2ef"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "58a83da64b46f34f8bf8489bdd3b4377cb48429ae2f778fe1a0a5400eee1bb7f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8d7771df78e5ef8d39cedf27bd176f086641ea9657fb3465addff275b59f62f3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fbfcd1a36767a08c0168ff6c23bb3d7882abf64b5965b9c6de5be4269c6b97fd"
    sha256 cellar: :any_skip_relocation, sonoma:         "499877f1fd62066bf8f55439af6bd6db2868f5df263ece89c43fe8b2b95bb1ed"
    sha256 cellar: :any_skip_relocation, ventura:        "2af5beda03bef0933c6ceed9d7b0bb4aacc4f27785d09ca21994c076b0142cdb"
    sha256 cellar: :any_skip_relocation, monterey:       "eeef5e4aaa094f157c84dd90e17d1a01a7828c55c99e322aa9a86c0a791f64b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4215058c50a993a008ed876593dcddc082802d0feff3c3f90d122ecaa1ca2597"
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
