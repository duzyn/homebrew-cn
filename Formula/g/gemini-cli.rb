class GeminiCli < Formula
  desc "Interact with Google Gemini AI models from the command-line"
  homepage "https://github.com/google-gemini/gemini-cli"
  url "https://registry.npmjs.org/@google/gemini-cli/-/gemini-cli-0.28.1.tgz"
  sha256 "369072c1202ea5ddbd0941e549b0d6d8769a48c2ec86f5b4eba711fa9fcb8870"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "43659946c67bfc827a82a7512fa551b2d28331cdb8a5a4ec6caa201fc6282379"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "43659946c67bfc827a82a7512fa551b2d28331cdb8a5a4ec6caa201fc6282379"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "43659946c67bfc827a82a7512fa551b2d28331cdb8a5a4ec6caa201fc6282379"
    sha256 cellar: :any_skip_relocation, sonoma:        "0d8791cde65fada13fc99f487c76e0dcb683767a7a167c9b793d2d674494c970"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "abd9351135b804dea281519ab198b145552cd35a8d0f44f2d70e6cd2418e734c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6f995ac815f629c55c2f31bf6011657162a13d9ef23a0032da53c8852a1fda37"
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
