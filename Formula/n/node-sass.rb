class NodeSass < Formula
  require "language/node"

  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.77.3.tgz"
  sha256 "56ccf0665c91df5ee800688d9556bd101f614f434e4b70371b48471aea6a4b65"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a5ea22cc03a3f1812b66a46c306818c0e236718f0497e4fc85a7fdda27bb1c83"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a5ea22cc03a3f1812b66a46c306818c0e236718f0497e4fc85a7fdda27bb1c83"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a5ea22cc03a3f1812b66a46c306818c0e236718f0497e4fc85a7fdda27bb1c83"
    sha256 cellar: :any_skip_relocation, sonoma:         "a5ea22cc03a3f1812b66a46c306818c0e236718f0497e4fc85a7fdda27bb1c83"
    sha256 cellar: :any_skip_relocation, ventura:        "a5ea22cc03a3f1812b66a46c306818c0e236718f0497e4fc85a7fdda27bb1c83"
    sha256 cellar: :any_skip_relocation, monterey:       "a5ea22cc03a3f1812b66a46c306818c0e236718f0497e4fc85a7fdda27bb1c83"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b1f53b9939e7ab3c96f3ec4c6665d906867a5914d436d973849992ad8568be38"
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
