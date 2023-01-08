require "language/node"

class Lerna < Formula
  desc "Tool for managing JavaScript projects with multiple packages"
  homepage "https://lerna.js.org"
  url "https://registry.npmjs.org/lerna/-/lerna-6.4.0.tgz"
  sha256 "5f5600ad8c76a14360a1177bd4debfcfc0f463d5f1b88477eb4a4f121b48ddcb"
  license "MIT"

  bottle do
    sha256                               arm64_ventura:  "ef157c1c25efaa785cefcf599de88525c3e2973303e595b6d77f87d28d732110"
    sha256                               arm64_monterey: "715944672816b0bb9222334fe7013b90bd76547ea780bb1ea39a54e8f81a848b"
    sha256                               arm64_big_sur:  "e1823dad58666254a9d881a7b6e6362af40ce5fb6858f80b01ce46eaa2403e86"
    sha256                               ventura:        "5132eb43e8bbe658a3df50428f704a2c8bf18d901f11ab9ed4ad3d41c3f42b3a"
    sha256                               monterey:       "ab42eaa0d95824b565c1adc24d06b7a5aaa616b81ee9c20b04d6137a3f81de26"
    sha256                               big_sur:        "89f5acbfd3d56241008f39da61455b755968e95a829dd40b0648cf48f5b972c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "822c6c7d6aa17922797480a19263a0c83dbd621c8c14686e4d9ed40ce609a4b7"
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
