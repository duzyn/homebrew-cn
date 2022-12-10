require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.16.3.tgz"
  sha256 "30965966af5c41bf705c0ebbed34a16b737bd60cba600e0ce187b2cc8b68a0b7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2bb7f290d402992cd94b5e2d299c2a1a59373ecf519666c1bad0da41cdddebf3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2bb7f290d402992cd94b5e2d299c2a1a59373ecf519666c1bad0da41cdddebf3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2bb7f290d402992cd94b5e2d299c2a1a59373ecf519666c1bad0da41cdddebf3"
    sha256 cellar: :any_skip_relocation, ventura:        "59f7eae02b9817152202e18a5101f9845a79d2b967fb44676a8a61ab3645c9db"
    sha256 cellar: :any_skip_relocation, monterey:       "59f7eae02b9817152202e18a5101f9845a79d2b967fb44676a8a61ab3645c9db"
    sha256 cellar: :any_skip_relocation, big_sur:        "59f7eae02b9817152202e18a5101f9845a79d2b967fb44676a8a61ab3645c9db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7f0f4ebf87058148f953d1dda33b0aacccf2a3cad8388190f8fb89ad69d2d971"
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
