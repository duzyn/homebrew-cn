class AgentBrowser < Formula
  desc "Browser automation CLI for AI agents"
  homepage "https://agent-browser.dev/"
  url "https://registry.npmjs.org/agent-browser/-/agent-browser-0.20.11.tgz"
  sha256 "6190ce16330e45e9f0bacdae20349ea3d5efb5dd8b5e7308ed0e0dcfe8e1001f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "488f2dd5a36ca3cf89be1383cca947d70f91d56791b4406d18b07cff802f6a98"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "488f2dd5a36ca3cf89be1383cca947d70f91d56791b4406d18b07cff802f6a98"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "488f2dd5a36ca3cf89be1383cca947d70f91d56791b4406d18b07cff802f6a98"
    sha256 cellar: :any_skip_relocation, sonoma:        "2678125c9cc0c8e3fc2abd13965549d887b82c71103db0c530d9f10c3081d846"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b60cb70c20f0686c60cdb827f3583a6ad84633308c0f082ab2d54debc0d0d35e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2ad061672a2b326d4ffee0c4a904980cb31a96ec73224e354625d5395688dbe4"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Remove non-native platform binaries and make native binary executable
    node_modules = libexec/"lib/node_modules/agent-browser"
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : "arm64"
    (node_modules/"bin").glob("agent-browser-*").each do |f|
      if f.basename.to_s == "agent-browser-#{os}-#{arch}"
        f.chmod 0755
      else
        rm f
      end
    end

    # Remove non-native prebuilds from dependencies
    node_modules.glob("node_modules/*/prebuilds/*").each do |prebuild_dir|
      rm_r(prebuild_dir) if prebuild_dir.basename.to_s != "#{os}-#{arch}"
    end
  end

  def caveats
    <<~EOS
      To complete the installation, run:
        agent-browser install
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/agent-browser --version")

    # Verify session list subcommand works without a browser daemon
    assert_match "No active sessions", shell_output("#{bin}/agent-browser session list")

    # Verify CLI validates commands and rejects unknown ones
    output = shell_output("#{bin}/agent-browser nonexistentcommand 2>&1", 1)
    assert_match "Unknown command", output
  end
end
