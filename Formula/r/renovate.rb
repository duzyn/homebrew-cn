require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.10.0.tgz"
  sha256 "20547548fe5b3609e478006735298dbba2f973c5f155eab979a492e393dba359"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8c276b9058d13824d92edc33207d226114cfcb03328afc3a02f0a391ec7208c6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9a405432be4b9b255cdcb72468d01da761b5738ac48c1d8986fbdee069b14dae"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "75af5517ead15619d286e444fc347fbb567e8041481574092abd08020628aaad"
    sha256 cellar: :any_skip_relocation, sonoma:         "6ba1bbf121a7b9887c590dcb57fffcc7c434ff23441a3678088187a57397dca9"
    sha256 cellar: :any_skip_relocation, ventura:        "18d1b408d57228b1d9eef8f6b094e4ced2d5432fd2182118ff4961c7d9bfca3a"
    sha256 cellar: :any_skip_relocation, monterey:       "a35d2df53aeb7df9577ad1a5dd09956ad6918f554939db9937dfd632c09837f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "45384ac3cb555a22b2d5045591630a8ade3709fd64852ce367d466c2740a1b69"
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
