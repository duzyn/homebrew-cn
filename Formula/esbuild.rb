require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.16.8.tgz"
  sha256 "294befb4f3ec7d51e679c832009c784b05927031bca64af187038d3182cc303a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "361aa8f255b86c303764fc0e00ecc7c45bc69ed92160d3dfe5424e77e90078fc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "361aa8f255b86c303764fc0e00ecc7c45bc69ed92160d3dfe5424e77e90078fc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "361aa8f255b86c303764fc0e00ecc7c45bc69ed92160d3dfe5424e77e90078fc"
    sha256 cellar: :any_skip_relocation, ventura:        "0b3aa75e17fce1e6047eb65aeb77a3c55e3a2d1baaab9b23f4ac33593bcd6ba8"
    sha256 cellar: :any_skip_relocation, monterey:       "0b3aa75e17fce1e6047eb65aeb77a3c55e3a2d1baaab9b23f4ac33593bcd6ba8"
    sha256 cellar: :any_skip_relocation, big_sur:        "0b3aa75e17fce1e6047eb65aeb77a3c55e3a2d1baaab9b23f4ac33593bcd6ba8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1dc514eb7869ce2ccbfd7d7584c007f24f3267e2f4609b4c9f138da83173d359"
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
