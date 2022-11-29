require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.15.16.tgz"
  sha256 "3866e4e023a14b635be64d4532ec1bd94e8f09976decc9f80e070c5765821d39"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0b781cea016c205daeb9b65992224e0e7cc6b162be76b9711fecb4e3a7eff471"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0b781cea016c205daeb9b65992224e0e7cc6b162be76b9711fecb4e3a7eff471"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0b781cea016c205daeb9b65992224e0e7cc6b162be76b9711fecb4e3a7eff471"
    sha256 cellar: :any_skip_relocation, ventura:        "26cedb4e40b63ef7479c02057fe29526b658e79c580246f26da347c998571b9b"
    sha256 cellar: :any_skip_relocation, monterey:       "26cedb4e40b63ef7479c02057fe29526b658e79c580246f26da347c998571b9b"
    sha256 cellar: :any_skip_relocation, big_sur:        "26cedb4e40b63ef7479c02057fe29526b658e79c580246f26da347c998571b9b"
    sha256 cellar: :any_skip_relocation, catalina:       "26cedb4e40b63ef7479c02057fe29526b658e79c580246f26da347c998571b9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c58727af2306e53064d11ae00e490c683ae4f46ba3d2c609f52e62b8449bb946"
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
