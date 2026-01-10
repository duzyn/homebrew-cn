class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://docs.balena.io/reference/balena-cli/latest/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-23.2.16.tgz"
  sha256 "ce4b6c9306b988bad3853688bbca307a94464a1f03c1d4ccbe11ab133ea2a371"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bbf13494a231c63fc132d2411e1bd57929b424988a86b42bcbe4e9b94c9d0bc6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "414bb3f790672677925019af06605971ecccd1570843f510511fef046a0961e8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "414bb3f790672677925019af06605971ecccd1570843f510511fef046a0961e8"
    sha256 cellar: :any_skip_relocation, sonoma:        "d58299c4aa46a1b08d08a0ce56ab67afd2bf2b311bd7e166907a69a7121685ff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8fe3335f62741a7ef8c446bb2108ae5b157c3d1c054df1e62574f21a0113c3f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ae97416208c92e9466bd05aafc9339652477e9243931d118f792f0e38ce57a69"
  end

  # align with upstream, https://github.com/balena-io/balena-cli/blob/master/.github/actions/publish/action.yml#L21
  depends_on "node@22"

  on_linux do
    depends_on "libusb"
    depends_on "systemd" # for libudev
    depends_on "xz" # for liblzma
  end

  def install
    ENV.deparallelize

    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Remove incompatible pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/balena-cli/node_modules"
    node_modules.glob("{bcrypt,lzma-native,mountutils}/prebuilds/*")
                .each do |dir|
                  if dir.basename.to_s == "#{os}-#{arch}"
                    dir.glob("*.musl.node").each(&:unlink) if OS.linux?
                  else
                    rm_r(dir)
                  end
                end

    rm_r(node_modules/"usb") if OS.linux?

    # Replace universal binaries with native slices
    deuniversalize_machos
  end

  test do
    assert_match "Logging in to balena-cloud.com",
      shell_output("#{bin}/balena login --credentials --email johndoe@gmail.com --password secret 2>/dev/null", 1)
  end
end
