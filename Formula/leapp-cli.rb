require "language/node"

class LeappCli < Formula
  desc "Cloud credentials manager cli"
  homepage "https://github.com/noovolari/leapp"
  url "https://registry.npmjs.org/@noovolari/leapp-cli/-/leapp-cli-0.1.27.tgz"
  sha256 "94291cf5dc98dad11a23eb91ed94df708a1b72e711d4a789c2535d355b49b46b"
  license "MPL-2.0"

  bottle do
    rebuild 1
    sha256                               arm64_ventura:  "90e0c7f474f2434f11a09d522c3bf97838e4802910b32ab89c6de61cdb34c3ed"
    sha256                               arm64_monterey: "91a40880308ed188fd1c742410ade897fd797f23e856685654393bf1246cebd2"
    sha256                               arm64_big_sur:  "468bb07d55ea4ac76231e2ba68b645852faab78229f30326c66ddc8d03be1429"
    sha256                               ventura:        "5939c17edece1adeb97ca719051c5d991bc74a8f712a57673d0350c8eab200ce"
    sha256                               monterey:       "478ca3919d9ef5c0d89ca267871a067c7220b64f40a4ef4823b6c5568a48fae2"
    sha256                               big_sur:        "79f5ae66c39096df00518bbc80ce2e2dbc02756430f9e2cc81f47055c09fb163"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "93b73da27b713c2bbed090f7dbd9b1b657db24988924bea325fbef60182f331e"
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
