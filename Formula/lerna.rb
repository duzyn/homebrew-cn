require "language/node"

class Lerna < Formula
  desc "Tool for managing JavaScript projects with multiple packages"
  homepage "https://lerna.js.org"
  url "https://registry.npmjs.org/lerna/-/lerna-6.3.0.tgz"
  sha256 "3562a20946f5abe268f71b1c7c4b1adf569d60a631fec4ab878a3d1896cdea4e"
  license "MIT"

  bottle do
    sha256                               arm64_ventura:  "2b95d109dcfdf8d623d8f185273be364441569713478cdbb986bda827ee27ae0"
    sha256                               arm64_monterey: "248e95f539aa771d1e28262570e25e701a797d0782428d57d3b58cccd8b60f31"
    sha256                               arm64_big_sur:  "d05e661a4d7c7efd2432f22f23c688665f18c4677b1af8ed0f23ed49be79893a"
    sha256                               ventura:        "ded2f480d9f61460fbd81e3533735508680efbe5bfc0a90ba45ce3c45ff649f8"
    sha256                               monterey:       "b1c1ada3a159838e46044329829c17f6e51d63b202ef4e9acd107c1d8318fea5"
    sha256                               big_sur:        "ae6301dbccc1063d882f1ab3e47c4804124a204117abb752e157ed5010b61c0d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8735b7fae9b3c8d02563c3b21af365afa76fc2c4cdffa81fbca8cdf34b6b7387"
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
