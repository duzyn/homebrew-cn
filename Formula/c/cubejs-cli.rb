require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.35.16.tgz"
  sha256 "40aac22e004b9b7e39705bbf1c190b781ce873a8301c23dcdd0c8440d92bffb3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b3e5c5d7c21b2e35756df363660e952793289d5b9f0c72cde0c2f8fa896b0b41"
    sha256 cellar: :any,                 arm64_ventura:  "b3e5c5d7c21b2e35756df363660e952793289d5b9f0c72cde0c2f8fa896b0b41"
    sha256 cellar: :any,                 arm64_monterey: "b3e5c5d7c21b2e35756df363660e952793289d5b9f0c72cde0c2f8fa896b0b41"
    sha256 cellar: :any,                 sonoma:         "b3380c2c3215c242cc3473c76b19cdba2f9d3b9caee10d456a32db5ea726a545"
    sha256 cellar: :any,                 ventura:        "b3380c2c3215c242cc3473c76b19cdba2f9d3b9caee10d456a32db5ea726a545"
    sha256 cellar: :any,                 monterey:       "b3380c2c3215c242cc3473c76b19cdba2f9d3b9caee10d456a32db5ea726a545"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "38dc90418d416733598cb00dbe89688dc7e090ea5d620be2e3c61904a3a3f69f"
  end

  depends_on "node"
  uses_from_macos "zlib"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cubejs --version")
    system bin/"cubejs", "create", "hello-world", "-d", "postgres"
    assert_predicate testpath/"hello-world/model/cubes/orders.yml", :exist?
  end
end
