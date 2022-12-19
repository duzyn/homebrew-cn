require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.16.9.tgz"
  sha256 "0735800f40c35b4935bd7f244bae2e2fd89d50a2bf5bf731359b6ee60aa3ee07"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ae93ef9ea07b624bc6a8f9198c12135e477ea070bb190af3facb4fb08d280d2c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ae93ef9ea07b624bc6a8f9198c12135e477ea070bb190af3facb4fb08d280d2c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ae93ef9ea07b624bc6a8f9198c12135e477ea070bb190af3facb4fb08d280d2c"
    sha256 cellar: :any_skip_relocation, ventura:        "4d4b5715d76b191b6fedcf38d450477af568444c8b40150aebe7236aadf62b6d"
    sha256 cellar: :any_skip_relocation, monterey:       "4d4b5715d76b191b6fedcf38d450477af568444c8b40150aebe7236aadf62b6d"
    sha256 cellar: :any_skip_relocation, big_sur:        "4d4b5715d76b191b6fedcf38d450477af568444c8b40150aebe7236aadf62b6d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2c4cf82d40c2c22293fd2f96f918d99481453b3d0f826f9118f7ad1f6265c723"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"app.jsx").write <<~EOS
      import * as React from 'react'
      import * as Server from 'react-dom/server'

      let Greet = () => <h1>Hello, world!</h1>
      console.log(Server.renderToString(<Greet />))
    EOS

    system Formula["node"].libexec/"bin/npm", "install", "react", "react-dom"
    system bin/"esbuild", "app.jsx", "--bundle", "--outfile=out.js"

    assert_equal "<h1>Hello, world!</h1>\n", shell_output("node out.js")
  end
end
