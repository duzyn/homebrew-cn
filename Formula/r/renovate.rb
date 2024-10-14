class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-38.121.0.tgz"
  sha256 "9500e8d5e53aada3f322d5aad981f30cd7818c41b8e8cd4e6442334a85b3a05b"
  license "AGPL-3.0-only"

  # There are thousands of renovate releases on npm and the page the `Npm`
  # strategy checks is several MB in size and can time out before the request
  # resolves. This checks the first page of tags on GitHub (to minimize data
  # transfer).
  livecheck do
    url "https://github.com/renovatebot/renovate/tags"
    regex(%r{href=["']?[^"' >]*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
    strategy :page_match
    throttle 10
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6bae5227185e94ad389b932aaa3ce1269ae493d96f237e42caec984d60d53c16"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bd0902d4621544ff39e260943c766ea295daddd25d5590030d64127f7f089d2a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f2093be56ea2320564979425530825a9476a1b3bc6a68014865d0d3d99df114a"
    sha256 cellar: :any_skip_relocation, sonoma:        "52cf9fc81890bea067e7ff5e7ff595abaf3e735eb5e18a91784674f39f533a24"
    sha256 cellar: :any_skip_relocation, ventura:       "ba7edaa66006f2edba95a82b04186973554425dd9999ae0c2b7a7eae5a1dbb98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b68dbc72a19de56eed992f5b4810ebecd79d41bb664a016ccf3e491fef858c02"
  end

  depends_on "node@20"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"renovate", "--platform=local", "--enabled=false"
  end
end
