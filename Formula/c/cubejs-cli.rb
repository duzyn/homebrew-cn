class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.36.10.tgz"
  sha256 "067389e70b60f4138652cc19e006ffc7b31869266b9ea6185f08b33a040823bb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "025c5d4a4d07961280465fb27068b65852ce0e017a5cb7e3d553651fb04fae55"
    sha256 cellar: :any,                 arm64_sonoma:  "025c5d4a4d07961280465fb27068b65852ce0e017a5cb7e3d553651fb04fae55"
    sha256 cellar: :any,                 arm64_ventura: "025c5d4a4d07961280465fb27068b65852ce0e017a5cb7e3d553651fb04fae55"
    sha256 cellar: :any,                 sonoma:        "df94d25a63c97c409398c28f04b3aa66992a42914849e6629b67b2fda6c69940"
    sha256 cellar: :any,                 ventura:       "df94d25a63c97c409398c28f04b3aa66992a42914849e6629b67b2fda6c69940"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "74d6a0b32ea087d9b39649d5e8708cbabfb6ceaafb7e1325c7fb7832bfb8c594"
  end

  depends_on "node"
  uses_from_macos "zlib"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cubejs --version")
    system bin/"cubejs", "create", "hello-world", "-d", "postgres"
    assert_predicate testpath/"hello-world/model/cubes/orders.yml", :exist?
  end
end
