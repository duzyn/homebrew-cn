require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.35.14.tgz"
  sha256 "bbfe4c22af820453fdbd14f11839ff9aa73ff12e78c344da652d52ae30ef2b58"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "5eda703ec1b00eddb2072850415c7ee3590b7d84155b7e5076e2c666aa852eaa"
    sha256 cellar: :any,                 arm64_ventura:  "5eda703ec1b00eddb2072850415c7ee3590b7d84155b7e5076e2c666aa852eaa"
    sha256 cellar: :any,                 arm64_monterey: "5eda703ec1b00eddb2072850415c7ee3590b7d84155b7e5076e2c666aa852eaa"
    sha256 cellar: :any,                 sonoma:         "163bb46c754d54bb8675d0bb7e1ce5045e1bb709746f3aeb051e2a8460be7d1a"
    sha256 cellar: :any,                 ventura:        "163bb46c754d54bb8675d0bb7e1ce5045e1bb709746f3aeb051e2a8460be7d1a"
    sha256 cellar: :any,                 monterey:       "163bb46c754d54bb8675d0bb7e1ce5045e1bb709746f3aeb051e2a8460be7d1a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "874692b5bcd48123edda39733b6fc7c5576b6ea7693ecb429d1f79787956b013"
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
