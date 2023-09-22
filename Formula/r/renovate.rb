require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-36.102.0.tgz"
  sha256 "e934e9b0fca18b6b1fd58375b8062289680fc44d543a391c41c830c507a3549d"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ac69c8444ab64c0b6d1615ba5f6dacb3f7681c04cd47dc00ee0080050f97e14d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fd6ba29b6b2130c598fa85cc4400f2f1bc1ef4893d5557732fdf3ef82c6950d2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4d4554eb96f19be6e68cb6a09a6c853a34082afb7854d9c8c474ae71f5288d86"
    sha256 cellar: :any_skip_relocation, ventura:        "1b16d513e5f9cc0f6fc91e03754eaab1744ba40b45b06fcd09be20c93ed4da6e"
    sha256 cellar: :any_skip_relocation, monterey:       "ef6f9a977f8cc369fa4aeeb35c25c45e958ccff64ba93cf0f509a999b988dc1b"
    sha256 cellar: :any_skip_relocation, big_sur:        "b3f66812a55769a195648a9d51183784b6fbfd512ce5408d09526195c2edacea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2ee2e97f8c38031bf7025ce0b12d9c94a473dcfe7da8b2594bc44045a45475f9"
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
