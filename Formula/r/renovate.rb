class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-40.38.0.tgz"
  sha256 "8c4b215af161e754fb2270be83e0e465d145a22984d460f70a50c8e58d227174"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7d9dab5332718da18c613ce5986988b6f78bdf6c7056bd3dfd31d38715de5505"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4b1b059cbfd95369a8116da26c710c838b034506b0d2b4d96ce501f05feb6ad7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "786221062d667323483011cb56f79736186203fd35c04a4dfff728de50e68d10"
    sha256 cellar: :any_skip_relocation, sonoma:        "0250c2d1b24318bab340abaf29bafb24011fd587d25b9330624d941ffec2a162"
    sha256 cellar: :any_skip_relocation, ventura:       "4375a4bceb6f1b80ea014e39f4156dfb4e89001df19d07e53504901df9aab8dd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "feeed288838934fc8d1460137938230092d4643f1bb6536ab9b907dd79c91eab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "47b2fe5cd65d569e725ebb01b31717802ed1298d75d7827e8da681b4c2c40692"
  end

  depends_on "node@22"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"renovate", "--platform=local", "--enabled=false"
  end
end
