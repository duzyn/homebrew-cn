require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.33.60.tgz"
  sha256 "564a910f9e000c1c05ae8ca627b7ae08d128507367586baa245f64321a4df5c3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "d17000a464bdd3b00ca3f5fa7afc2ecf70c12a604f536e03a8ef5a0fe8ea1062"
    sha256 cellar: :any, arm64_monterey: "d17000a464bdd3b00ca3f5fa7afc2ecf70c12a604f536e03a8ef5a0fe8ea1062"
    sha256 cellar: :any, arm64_big_sur:  "d17000a464bdd3b00ca3f5fa7afc2ecf70c12a604f536e03a8ef5a0fe8ea1062"
    sha256 cellar: :any, ventura:        "5f058930ef22adf9cf6e87a8109dcd114f52a1e092dfa60713bdf04eef2dac43"
    sha256 cellar: :any, monterey:       "5f058930ef22adf9cf6e87a8109dcd114f52a1e092dfa60713bdf04eef2dac43"
    sha256 cellar: :any, big_sur:        "5f058930ef22adf9cf6e87a8109dcd114f52a1e092dfa60713bdf04eef2dac43"
  end

  depends_on "node"

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
