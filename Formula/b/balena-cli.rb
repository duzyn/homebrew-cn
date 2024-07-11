require "language/node"

class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://www.balena.io/docs/reference/cli/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-18.2.23.tgz"
  sha256 "3b5b753ac860ac9d2a2b69b4439b60ac83683785afa2522ae5fad6fdb1fdf649"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256                               arm64_sonoma:   "a24450069bfa9f9d1ce3a3c52a73a5c3e559b481685327397782b76ad0e2efdf"
    sha256                               arm64_ventura:  "eee5ae5e37eb68ec8915f256915ab244b9c69094bcedc5fda11342cf206ac463"
    sha256                               arm64_monterey: "ffe2eaf743e00371b9a2e05ac7310d0411d164681bb93c5e09a4e8ecd064a2eb"
    sha256                               sonoma:         "c127c4840298c92be7a88b140b8052878ddc8df1189fd714bc52b69fc74ce870"
    sha256                               ventura:        "2b2cafb0b68324d59008ef8b35e4ce29d2e4d343661a075eda1f146a66cb50ac"
    sha256                               monterey:       "e470d638cfd1d97e198ce20b806dc0bca669a637f45f83ea160672784121d7e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bf93ea926c03179b6e97e92eb516001fb7c677d8e824ae9866bbdc4e7c0bdcd5"
  end

  # need node@20, and also align with upstream, https://github.com/balena-io/balena-cli/blob/master/.github/actions/publish/action.yml#L21
  depends_on "node@20"

  on_macos do
    depends_on "macos-term-size"
  end

  on_linux do
    depends_on "libusb"
    depends_on "systemd" # for libudev
    depends_on "xz" # for liblzma
  end

  def install
    ENV.deparallelize

    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove incompatible pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/balena-cli/node_modules"
    node_modules.glob("{ffi-napi,ref-napi}/prebuilds/*")
                .each { |dir| dir.rmtree if dir.basename.to_s != "#{os}-#{arch}" }

    (node_modules/"lzma-native/build").rmtree
    (node_modules/"usb").rmtree if OS.linux?

    term_size_vendor_dir = node_modules/"term-size/vendor"
    term_size_vendor_dir.rmtree # remove pre-built binaries

    if OS.mac?
      macos_dir = term_size_vendor_dir/"macos"
      macos_dir.mkpath
      # Replace the vendored pre-built term-size with one we build ourselves
      ln_sf (Formula["macos-term-size"].opt_bin/"term-size").relative_path_from(macos_dir), macos_dir

      unless Hardware::CPU.intel?
        # Replace pre-built x86_64 binaries with native binaries
        %w[denymount macmount].each do |mod|
          (node_modules/mod/"bin"/mod).unlink
          system "make", "-C", node_modules/mod
        end
      end
    end

    # Replace universal binaries with native slices
    deuniversalize_machos
  end

  test do
    ENV.prepend_path "PATH", Formula["node@20"].bin

    assert_match "Logging in to balena-cloud.com",
      shell_output("#{bin}/balena login --credentials --email johndoe@gmail.com --password secret 2>/dev/null", 1)
  end
end
