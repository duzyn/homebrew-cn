require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.52.0.tgz"
  sha256 "b8cb5a1c1007df9ca940761f116fa8b336c9d04b8f7afcfadbab98f4f5880ed7"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "817660a2eeb7c3437d8694a62a3f751ad7119071b07222f252c1027af67ae8fc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ab807cfbfab2e85c8cbeab838097735753e0ede1c1be6c6a7c4292cc2da1b0aa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ec9769a6a58f54a6cb92c857a7e94cedb6198ea7e51ad5a892f777d3378bb117"
    sha256 cellar: :any_skip_relocation, sonoma:         "8b331fea9960bd335bdca6a022d90af1bbab1894d90bd3350891b8bf80d651b3"
    sha256 cellar: :any_skip_relocation, ventura:        "88f0348d3b8fb3fbff9a68a1f54a12903894e13cabe6302fb22c95879f381db1"
    sha256 cellar: :any_skip_relocation, monterey:       "561887bd6c5962247e1f8649e326054d5d5fc263f4152a2bdb0ac28052485dc3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "09e86c934726870ab16a0580c880a9212e5ebe1b16ed5a8ad91566b8e64c11cb"
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
