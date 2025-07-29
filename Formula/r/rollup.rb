class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.46.1.tgz"
  sha256 "7bcaa1356e31daa753ca7c00aa38b163be8f44bd00c4d2bce2b2cc9f5768aa0d"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "6645437e88ec0a72894d21e73cc61f702a17d618d6ba243bf4fbbfcc505ab922"
    sha256 cellar: :any,                 arm64_sonoma:  "6645437e88ec0a72894d21e73cc61f702a17d618d6ba243bf4fbbfcc505ab922"
    sha256 cellar: :any,                 arm64_ventura: "6645437e88ec0a72894d21e73cc61f702a17d618d6ba243bf4fbbfcc505ab922"
    sha256 cellar: :any,                 sonoma:        "6b56049bbcb1c5b664513f257cfe04f1c09426ebb1aca93e907c55aa8eca1ebf"
    sha256 cellar: :any,                 ventura:       "6b56049bbcb1c5b664513f257cfe04f1c09426ebb1aca93e907c55aa8eca1ebf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a26db81076bcc85a7511f68c97e7bfc65a49d68f4cf49e3d79a3f30131bb64ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "550231a580999da62eb92b3e2ec59177c3734f1e148d7bbe7d4b53917ed59f0f"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test/main.js").write <<~JS
      import foo from './foo.js';
      export default function () {
        console.log(foo);
      }
    JS

    (testpath/"test/foo.js").write <<~JS
      export default 'hello world!';
    JS

    expected = <<~JS
      'use strict';

      var foo = 'hello world!';

      function main () {
        console.log(foo);
      }

      module.exports = main;
    JS

    assert_equal expected, shell_output("#{bin}/rollup #{testpath}/test/main.js -f cjs")
  end
end
