require "language/node"

class Quicktype < Formula
  desc "Generate types and converters from JSON, Schema, and GraphQL"
  homepage "https://github.com/quicktype/quicktype"
  # quicktype should only be updated every 10 releases on multiples of 10
  url "https://registry.npmjs.org/quicktype/-/quicktype-17.0.0.tgz"
  sha256 "21155a185d27c2d54d2da489f350a397d9e6444373f4bd9c9242ab085fe82506"
  license "Apache-2.0"
  head "https://github.com/quicktype/quicktype.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "453087fc85e054ea0773f8a2d9381ecfa2fca4ca5a8ea13d4ec2168532bbf0e6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "453087fc85e054ea0773f8a2d9381ecfa2fca4ca5a8ea13d4ec2168532bbf0e6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "453087fc85e054ea0773f8a2d9381ecfa2fca4ca5a8ea13d4ec2168532bbf0e6"
    sha256 cellar: :any_skip_relocation, ventura:        "10d91682539c80d8036330950baa92c8a2e470f46ebc152af893cdf88072165f"
    sha256 cellar: :any_skip_relocation, monterey:       "10d91682539c80d8036330950baa92c8a2e470f46ebc152af893cdf88072165f"
    sha256 cellar: :any_skip_relocation, big_sur:        "10d91682539c80d8036330950baa92c8a2e470f46ebc152af893cdf88072165f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "453087fc85e054ea0773f8a2d9381ecfa2fca4ca5a8ea13d4ec2168532bbf0e6"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"sample.json").write <<~EOS
      {
        "i": [0, 1],
        "s": "quicktype"
      }
    EOS
    output = shell_output("#{bin}/quicktype --lang typescript --src sample.json")
    assert_match "i: number[];", output
    assert_match "s: string;", output
  end
end
