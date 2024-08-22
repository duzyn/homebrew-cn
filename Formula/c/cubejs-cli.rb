class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.35.73.tgz"
  sha256 "5adb635b4579f5897a23d3ebe1a5034a69edb1bc29427602af5a9d4e282ae8d2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "9bec86a4d494bdd1c0ab85d0b660f8228c5fda5174a6f212da9d181861f669e9"
    sha256 cellar: :any,                 arm64_ventura:  "9bec86a4d494bdd1c0ab85d0b660f8228c5fda5174a6f212da9d181861f669e9"
    sha256 cellar: :any,                 arm64_monterey: "9bec86a4d494bdd1c0ab85d0b660f8228c5fda5174a6f212da9d181861f669e9"
    sha256 cellar: :any,                 sonoma:         "6aaee813da972c18f4b331e7849ddd31a9800d26357dfe3d48112ab16af93e9f"
    sha256 cellar: :any,                 ventura:        "6aaee813da972c18f4b331e7849ddd31a9800d26357dfe3d48112ab16af93e9f"
    sha256 cellar: :any,                 monterey:       "6aaee813da972c18f4b331e7849ddd31a9800d26357dfe3d48112ab16af93e9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ca92737de9446b1804807ba689609b0dc6bfd517006c825474ed84b939fe774e"
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
