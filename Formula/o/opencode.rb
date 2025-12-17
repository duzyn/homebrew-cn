class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.0.163.tgz"
  sha256 "a743ae11a8155574cf51d98e89fb056ccd01a050fd424ae8c1e135d7d721b078"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "25767080685d54f58e25c8a6221848fb3dc0d4bc2deb3325324e292e04299ce5"
    sha256                               arm64_sequoia: "25767080685d54f58e25c8a6221848fb3dc0d4bc2deb3325324e292e04299ce5"
    sha256                               arm64_sonoma:  "25767080685d54f58e25c8a6221848fb3dc0d4bc2deb3325324e292e04299ce5"
    sha256 cellar: :any_skip_relocation, sonoma:        "89835c7e01cd638fc30e06681620faf993868f02378d7303ccb83d4f07320303"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "922dec497f168e40a53ed9482768ba78f46ee0fe77769f9f7fd4e6a705a01469"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "53f60794f5c35264aeb6d5d4d7a89e297187fa8a66c050e97e9f397393d30d85"
  end

  depends_on "node"
  depends_on "ripgrep"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove binaries for other architectures, `-musl`, `-baseline`, and `-baseline-musl`
    arch = Hardware::CPU.arm? ? "arm64" : "x64"
    os = OS.linux? ? "linux" : "darwin"
    (libexec/"lib/node_modules/opencode-ai/node_modules").children.each do |d|
      next unless d.directory?

      rm_r d if d.basename.to_s != "opencode-#{os}-#{arch}"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/opencode --version")
    assert_match "opencode", shell_output("#{bin}/opencode models")
  end
end
