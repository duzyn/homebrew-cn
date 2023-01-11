require "language/node"

class LeappCli < Formula
  desc "Cloud credentials manager cli"
  homepage "https://github.com/noovolari/leapp"
  url "https://registry.npmjs.org/@noovolari/leapp-cli/-/leapp-cli-0.1.28.tgz"
  sha256 "8621a801368d735d779d27580b5e0f251d1348e0de38b6c898ba402af2b02075"
  license "MPL-2.0"

  bottle do
    sha256                               arm64_ventura:  "e2bcff46200cae28c7f49243295be82b4806c9b733c423c64083a81ed5a85bf2"
    sha256                               arm64_monterey: "e1689c1c3df2ca06c83d038d9e209671c26b0b9b1c908da9bc620490a957ba3f"
    sha256                               arm64_big_sur:  "9cc6c7e6a6d35007246ba7e34d81e2553893423aaddde285bf04c0a4ca786978"
    sha256                               ventura:        "3895bc65caedf85947c52fff5a36f3c65d79b50d2bb2288b705b4d0be5d4ebce"
    sha256                               monterey:       "ad68cb8e9be60166c11f9eae7255c4262f4d29b27c15c10e997e1527ae17a656"
    sha256                               big_sur:        "f029183d12a1c667303367af68b85cf947e881a635a9b2740f62641ed5b59f6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "142f43fecbf130d33a87a3ad57c580492a78e72d46260d1813009d3244bc5d5e"
  end

  depends_on "pkg-config" => :build
  depends_on "python@3.11" => :build
  depends_on "node"

  on_linux do
    depends_on "libsecret"
  end

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  def caveats
    <<~EOS
      This formula only installs the command-line utilities by default.

      Install Leapp.app with Homebrew Cask:
        brew install --cask leapp
    EOS
  end

  test do
    assert_match "Leapp app must be running to use this CLI",
      shell_output("#{bin}/leapp idp-url create --idpUrl https://example.com 2>&1", 2).strip
  end
end
