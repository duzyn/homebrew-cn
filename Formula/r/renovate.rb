class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-41.88.0.tgz"
  sha256 "add7a13066c213b2ff8ee46e89cbed337041e941de15648ac4426ac934aa9ee9"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "18f13d5f1ffb0a46068309f77e982e98df351fbb9fd0e5b767d9e82d1e6d7fb3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e6651e4520cd123fc8dc7bf17ce7b87430afac72ff04630d101c2aff478e4c85"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e561e59e14dc588e49dc034322d5b2e9c45f2fa8b8d9078e2189fb42ebb6bb4e"
    sha256 cellar: :any_skip_relocation, sonoma:        "116b4c829d117ff07d8509cd177f7a393e0558183b530be42e99aece094091ce"
    sha256 cellar: :any_skip_relocation, ventura:       "2108c02125c06aa7b4507bb570ad863b89ed867f06289d0ee91a152080cae2f2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "204512e9997ed2a077fa221a8fb7840b7ae4c19d92f4192e60a7f67ae66caf59"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f671172e68b90b1dd92796195c54ddd486e5b6a5f4e0e68099a5c85e0a93bcd7"
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
