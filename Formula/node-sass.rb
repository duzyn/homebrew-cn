class NodeSass < Formula
  require "language/node"

  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.56.2.tgz"
  sha256 "c6c6fe46c1988482cd981fbaf01fac5288d449124d6e1ad8e4ac11d21a80aab6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "251b6df30d5caae68c45485227733bf369806beecccb2f64ce21117ec134b2c6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "251b6df30d5caae68c45485227733bf369806beecccb2f64ce21117ec134b2c6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "251b6df30d5caae68c45485227733bf369806beecccb2f64ce21117ec134b2c6"
    sha256 cellar: :any_skip_relocation, ventura:        "251b6df30d5caae68c45485227733bf369806beecccb2f64ce21117ec134b2c6"
    sha256 cellar: :any_skip_relocation, monterey:       "251b6df30d5caae68c45485227733bf369806beecccb2f64ce21117ec134b2c6"
    sha256 cellar: :any_skip_relocation, big_sur:        "251b6df30d5caae68c45485227733bf369806beecccb2f64ce21117ec134b2c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "47de27f86c92afa9b85d63c42870cda303484bddfc3dc52d5dbb3c9b1cd78d43"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.scss").write <<~EOS
      div {
        img {
          border: 0px;
        }
      }
    EOS

    assert_equal "div img{border:0px}",
    shell_output("#{bin}/sass --style=compressed test.scss").strip
  end
end
