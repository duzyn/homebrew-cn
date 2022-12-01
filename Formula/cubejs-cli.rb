require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.31.19.tgz"
  sha256 "6e508f2b5fc1e42f858532ef696eb26417537765fd430b0abf49c5aa4dc5569c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "995f6e4d134b0ac60dbe02d47e299d82ad18388bf48dc1d4a43a23f159948b5e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "995f6e4d134b0ac60dbe02d47e299d82ad18388bf48dc1d4a43a23f159948b5e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "995f6e4d134b0ac60dbe02d47e299d82ad18388bf48dc1d4a43a23f159948b5e"
    sha256 cellar: :any_skip_relocation, ventura:        "4c1ba1b954c7e35b7f83c308a7ffab509bfe5e26ded8e7a1532c44be45e5ecb7"
    sha256 cellar: :any_skip_relocation, monterey:       "4c1ba1b954c7e35b7f83c308a7ffab509bfe5e26ded8e7a1532c44be45e5ecb7"
    sha256 cellar: :any_skip_relocation, big_sur:        "4c1ba1b954c7e35b7f83c308a7ffab509bfe5e26ded8e7a1532c44be45e5ecb7"
    sha256 cellar: :any_skip_relocation, catalina:       "4c1ba1b954c7e35b7f83c308a7ffab509bfe5e26ded8e7a1532c44be45e5ecb7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "995f6e4d134b0ac60dbe02d47e299d82ad18388bf48dc1d4a43a23f159948b5e"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cubejs --version")
    system "cubejs", "create", "hello-world", "-d", "postgres"
    assert_predicate testpath/"hello-world/schema/Orders.js", :exist?
  end
end
