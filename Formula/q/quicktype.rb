require "language/node"

class Quicktype < Formula
  desc "Generate types and converters from JSON, Schema, and GraphQL"
  homepage "https://github.com/quicktype/quicktype"
  url "https://registry.npmjs.org/quicktype/-/quicktype-23.0.149.tgz"
  sha256 "c659f135dc8159c22a985e2ca8c77629bcffd9aa784dc45d190120dfb5864ffb"
  license "Apache-2.0"
  head "https://github.com/quicktype/quicktype.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "368a278fa12904042a836d6ef367bb909261607511a050df82b297ba5a7bb970"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "368a278fa12904042a836d6ef367bb909261607511a050df82b297ba5a7bb970"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "368a278fa12904042a836d6ef367bb909261607511a050df82b297ba5a7bb970"
    sha256 cellar: :any_skip_relocation, sonoma:         "1d2c98c830af45b5953ae603cdfb8a02ff76671da9b42ef551147420165b7db8"
    sha256 cellar: :any_skip_relocation, ventura:        "1d2c98c830af45b5953ae603cdfb8a02ff76671da9b42ef551147420165b7db8"
    sha256 cellar: :any_skip_relocation, monterey:       "1d2c98c830af45b5953ae603cdfb8a02ff76671da9b42ef551147420165b7db8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "368a278fa12904042a836d6ef367bb909261607511a050df82b297ba5a7bb970"
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
