require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.16.7.tgz"
  sha256 "ad2fc674788265b96628d8089fd90f764a05552cfe50522db07237969770bed0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "30bbddbfb4d86a4a1d4c0bffee0e61e52b9b9206d8ec1d215256fb2f976a9425"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "30bbddbfb4d86a4a1d4c0bffee0e61e52b9b9206d8ec1d215256fb2f976a9425"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "30bbddbfb4d86a4a1d4c0bffee0e61e52b9b9206d8ec1d215256fb2f976a9425"
    sha256 cellar: :any_skip_relocation, ventura:        "b18f490ee85a80a59e1ecef4341b825d2d06f6f248c1f9d911c20ec4c9c44b53"
    sha256 cellar: :any_skip_relocation, monterey:       "b18f490ee85a80a59e1ecef4341b825d2d06f6f248c1f9d911c20ec4c9c44b53"
    sha256 cellar: :any_skip_relocation, big_sur:        "b18f490ee85a80a59e1ecef4341b825d2d06f6f248c1f9d911c20ec4c9c44b53"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a842eaf141609cb8e6087f35e1f5ef150feb55be43b0879c8a74874360a35848"
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
