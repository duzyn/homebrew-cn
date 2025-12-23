class GeminiCli < Formula
  desc "Interact with Google Gemini AI models from the command-line"
  homepage "https://github.com/google-gemini/gemini-cli"
  url "https://registry.npmjs.org/@google/gemini-cli/-/gemini-cli-0.22.0.tgz"
  sha256 "107754b0955c76a0dffbea4a3560b10393069fedb07f0fe0e0dc27c5481f908e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "71e68af07ca313de103d9c07a3125008c460a1337fa5e9f61dcf938fe6197e39"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "71e68af07ca313de103d9c07a3125008c460a1337fa5e9f61dcf938fe6197e39"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "71e68af07ca313de103d9c07a3125008c460a1337fa5e9f61dcf938fe6197e39"
    sha256 cellar: :any_skip_relocation, sonoma:        "31856848c5ca2b0a376ed88d03cc45107d7f1b90e2bf33abcf9c12b02d89ac0f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9d421d9dd97977b8f194222b5bc984247a3407e01a437856cc73e0a359f5f9dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2c3fee47f9e9a51ea07b35cdf2fc60b3456d2f5e2893f8dbec2cea33b9441f2b"
  end

  depends_on "node"

  on_linux do
    depends_on "xsel"
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove incompatible pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/@google/gemini-cli/node_modules"
    (node_modules/"tree-sitter-bash/prebuilds").glob("*")
                                               .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }
    (node_modules/"node-pty/prebuilds").glob("*")
                                       .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }

    clipboardy_fallbacks_dir = libexec/"lib/node_modules/@google/#{name}/node_modules/clipboardy/fallbacks"
    rm_r(clipboardy_fallbacks_dir) # remove pre-built binaries
    if OS.linux?
      linux_dir = clipboardy_fallbacks_dir/"linux"
      linux_dir.mkpath
      # Replace the vendored pre-built xsel with one we build ourselves
      ln_sf (Formula["xsel"].opt_bin/"xsel").relative_path_from(linux_dir), linux_dir
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gemini --version")

    assert_match "Please set an Auth method", shell_output("#{bin}/gemini --prompt Homebrew 2>&1", 41)
  end
end
