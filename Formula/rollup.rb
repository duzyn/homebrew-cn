require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-3.7.0.tgz"
  sha256 "ae1fa1d99612ddaf21c497398e67f1b1aa920987b6095fd364531862fd668f0f"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fecc6f8e364397c86f0f44d14f01b11ec6f1bfc2b06974ad2e6b2d9db32cec54"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fecc6f8e364397c86f0f44d14f01b11ec6f1bfc2b06974ad2e6b2d9db32cec54"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fecc6f8e364397c86f0f44d14f01b11ec6f1bfc2b06974ad2e6b2d9db32cec54"
    sha256 cellar: :any_skip_relocation, ventura:        "8496ae1923f19afa85a147c9d721f4088b8030b0d4ca0a2e9f474bc5f370a54f"
    sha256 cellar: :any_skip_relocation, monterey:       "8496ae1923f19afa85a147c9d721f4088b8030b0d4ca0a2e9f474bc5f370a54f"
    sha256 cellar: :any_skip_relocation, big_sur:        "8496ae1923f19afa85a147c9d721f4088b8030b0d4ca0a2e9f474bc5f370a54f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "53519e105d6903107d98a181eb257fcf3d998cebc7bdf51da26a9f816ecfdebc"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
    deuniversalize_machos
  end

  test do
    (testpath/"test/main.js").write <<~EOS
      import foo from './foo.js';
      export default function () {
        console.log(foo);
      }
    EOS

    (testpath/"test/foo.js").write <<~EOS
      export default 'hello world!';
    EOS

    expected = <<~EOS
      'use strict';

      var foo = 'hello world!';

      function main () {
        console.log(foo);
      }

      module.exports = main;
    EOS

    assert_equal expected, shell_output("#{bin}/rollup #{testpath}/test/main.js -f cjs")
  end
end
