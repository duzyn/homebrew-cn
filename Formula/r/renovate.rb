require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.116.0.tgz"
  sha256 "ddbf9b96c29d37909bc6e3a1ca39e006b6503ba205f748be9512b0164babc265"
  license "AGPL-3.0-only"

  # There are thousands of renovate releases on npm and page the `Npm` strategy
  # checks is several MB in size and can time out before the request resolves.
  # This checks the "latest" release, which doesn't have the same issues.
  livecheck do
    url "https://registry.npmjs.org/renovate/latest"
    regex(/v?(\d+(?:\.\d+)+)/i)
    strategy :json do |json, regex|
      json["version"]&.scan(regex) { |match| match[0] }
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cd02a4a9403b6cfb5f0668cf5590b15d8b75fcd419ac49d235c3d516227f6526"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "611788a6304bd03fda901644812c0ec7ef78517c6370e532bf05903797104731"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "143c62e8d413c493e413eae0b7afad082bde050a54abac8799e38a3519fef2bc"
    sha256 cellar: :any_skip_relocation, sonoma:         "cdf04b7fc4a6c4347558270961de7c1e96bd8c986fc09727fe55e0a7780d0d62"
    sha256 cellar: :any_skip_relocation, ventura:        "5242e08aa937dbd344d2dfa19f1bdb0e81528483b1ea9bc1c5987d4f6052882a"
    sha256 cellar: :any_skip_relocation, monterey:       "67e640abee6cac86c4001056130e697a9bf94976b5ec3c32e87887d084e51630"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6a85752e9a43b953b3030c16164d9616a599e5d03553d4c516f522f47f68ea07"
  end

  depends_on "node"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "FATAL: You must configure a GitHub token", shell_output("#{bin}/renovate 2>&1", 1)
  end
end
