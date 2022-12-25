require "language/node"

class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-4.2.5.tgz"
  sha256 "08f44ffbfa455d2e1089863b77a2ef6558be0017ff18e3030454d2dc1b87d340"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6c8003ed2300f74424439d20ea2204ad99d50bc23da29d0e52ff4bf7786d22ea"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_equal "<p>hello <em>world</em></p>", pipe_output("#{bin}/marked", "hello *world*").strip
  end
end
