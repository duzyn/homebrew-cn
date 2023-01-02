require "language/node"

class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://www.balena.io/docs/reference/cli/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-14.5.18.tgz"
  sha256 "716f65c337f001f42bc8b3eff40dabc67a528c90581264116f128d8b02b3a8ff"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256                               arm64_ventura:  "5099dc6a052e5c743d370dba7db2d3067a09ead84771b6de24c29692cddc028f"
    sha256                               arm64_monterey: "2a4b03ed112c224e573b64cb59bddb13a67ec39072f338e2ec4d8252b337d5b8"
    sha256                               arm64_big_sur:  "911fab39065d41c0919bf5600ac5da776223a8765492181c9f31fd89eca95f30"
    sha256                               ventura:        "4eedc3a4b7028a4330a5c85d1282a13d4a55866328d8363295b228068ce82cee"
    sha256                               monterey:       "4db83c0ade84ea883ddf304db871c125caa0c084c10990fdb6e5413bda5a4d8d"
    sha256                               big_sur:        "90200ed9b67a5dea46979dcd2d91c1c76d5e1a28661b3978154cfe0c322fa256"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "053ca659f81e6950288e7fca338137d0110cf223b46f6d73a7d2830824c4da58"
  end

  depends_on "node@14"

  on_macos do
    depends_on "macos-term-size"
  end

  def install
    ENV.deparallelize
    system Formula["node@14"].opt_bin/"npm", "install", *Language::Node.std_npm_install_args(libexec)
    (bin/"balena").write_env_script libexec/"bin/balena", PATH: "#{Formula["node@14"].opt_bin}:${PATH}"

    # Remove incompatible pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/balena-cli/node_modules"
    node_modules.glob("{ffi-napi,ref-napi}/prebuilds/*")
                .each { |dir| dir.rmtree if dir.basename.to_s != "#{os}-#{arch}" }

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

    # Replace universal binaries with their native slices.
    deuniversalize_machos
  end

  test do
    assert_match "Logging in to balena-cloud.com",
      shell_output("#{bin}/balena login --credentials --email johndoe@gmail.com --password secret 2>/dev/null", 1)
  end
end
