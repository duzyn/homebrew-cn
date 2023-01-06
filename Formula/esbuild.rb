require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.16.14.tgz"
  sha256 "741907c1f867c4e4b5b11e2c9523584dfd7cd288b891b156348f1b258e03f460"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1fc59ab3c901c4fdd33dfd1cda76003156a958ebdf9eff663ed4507c46dad3d8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1fc59ab3c901c4fdd33dfd1cda76003156a958ebdf9eff663ed4507c46dad3d8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1fc59ab3c901c4fdd33dfd1cda76003156a958ebdf9eff663ed4507c46dad3d8"
    sha256 cellar: :any_skip_relocation, ventura:        "e1f0d75de697755fbbf951bfcca332c3aa4db2aec7555bfd70d058a0286581ac"
    sha256 cellar: :any_skip_relocation, monterey:       "e1f0d75de697755fbbf951bfcca332c3aa4db2aec7555bfd70d058a0286581ac"
    sha256 cellar: :any_skip_relocation, big_sur:        "e1f0d75de697755fbbf951bfcca332c3aa4db2aec7555bfd70d058a0286581ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4fdeffbd457b21d7fb9f32ec4475656cdd2b9fc0354eeeed299d4ecb58ddc498"
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
