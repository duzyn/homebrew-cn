class GeminiCli < Formula
  desc "Interact with Google Gemini AI models from the command-line"
  homepage "https://github.com/google-gemini/gemini-cli"
  url "https://registry.npmjs.org/@google/gemini-cli/-/gemini-cli-0.30.1.tgz"
  sha256 "f8bd7ef81d85eff3faf4e4c6b0bac0862cbfd358f732993c2d8a757427b5a031"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c816d674919e5e2f0d67956c431faa5c79236ea631756949fc15f1b4a888d0bb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c816d674919e5e2f0d67956c431faa5c79236ea631756949fc15f1b4a888d0bb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c816d674919e5e2f0d67956c431faa5c79236ea631756949fc15f1b4a888d0bb"
    sha256 cellar: :any_skip_relocation, sonoma:        "18974fbccd616c221e5710b6d106a016f1c08b5d0d45a19c7761b1de3e5af492"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cd7fcdbc7bd11205991c3a1e5c210e41fc3b8b80485627351728477039cccee4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f055baa335523f4c42c1fe4df72f8dae530444ff68be671bc1434b3429b3e780"
  end

  depends_on "node"

  on_linux do
    depends_on "xsel"
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Remove incompatible pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/@google/gemini-cli/node_modules"
    (node_modules/"tree-sitter-bash/prebuilds").glob("*").each do |dir|
      rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}"
    end
    (node_modules/"node-pty/prebuilds").glob("*").each do |dir|
      rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}"
    end

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
