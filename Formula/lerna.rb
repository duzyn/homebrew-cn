require "language/node"

class Lerna < Formula
  desc "Tool for managing JavaScript projects with multiple packages"
  homepage "https://lerna.js.org"
  url "https://registry.npmjs.org/lerna/-/lerna-6.2.0.tgz"
  sha256 "540216da5b4e85e3825091262d4dba4dee2d37965a8ee966af76249651e2d79e"
  license "MIT"

  bottle do
    sha256                               arm64_ventura:  "3343825773caaf9ab8054b6e6d2ef4fd60d449927dc0d0834cf58f0b2f1fa98a"
    sha256                               arm64_monterey: "355e711dc9ed6ac21a7b4735ee4154065ad626e17474ae7abe47af588dcbc2e1"
    sha256                               arm64_big_sur:  "5973927ca1a81030f65e874847b668ea3afc75bf29a919b26c51ca163e4b5fbb"
    sha256                               ventura:        "3fac999702930e0e806fd1255d455fbdfe6c3528ece7dea84695857ccf595297"
    sha256                               monterey:       "fc2c09874361c7633eb7e0e91e758059790c7cff783e4b233d7ad210e64e1e7f"
    sha256                               big_sur:        "7965b6d9a78b3a2c83e5b0bacb8ee9b217d1d64e54ccad597286d743ccaef4a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fd351f1aed7c06c4070f58ade718cc88483bed6e23c74a5552459cf50eef2e8c"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/lerna/node_modules"
    (node_modules/"@parcel/watcher/prebuilds/linux-x64/node.napi.musl.node").unlink
    (node_modules/"@parcel/watcher/prebuilds").each_child { |dir| dir.rmtree if dir.basename.to_s != "#{os}-#{arch}" }

    # Replace universal binaries with native slices
    deuniversalize_machos
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lerna --version")

    output = shell_output("#{bin}/lerna init --independent 2>&1")
    assert_match "lerna success Initialized Lerna files", output
  end
end
