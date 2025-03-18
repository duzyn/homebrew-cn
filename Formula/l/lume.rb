class Lume < Formula
  desc "Create and manage Apple Silicon-native virtual machines"
  homepage "https://github.com/trycua/computer"
  url "https://mirror.ghproxy.com/https://github.com/trycua/computer/archive/refs/tags/lume-v0.1.17.tar.gz"
  sha256 "500958838bab32743e9cb6fa4970cb14e86dec1c3c9228a21dc706e0a20a47f6"
  license "MIT"
  head "https://github.com/trycua/computer.git", branch: "main"

  livecheck do
    url :stable
    regex(/^(?:lume[._-])?v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "98f762b5aca3b54bb0c6b88f3e1ff255e1ba8993679d9102b3a95e53b29d92fa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f8c40105451369b06eb6536a4cc6c49922536133db30f637c05e9bc75cf579ed"
  end

  depends_on xcode: ["16.0", :build]
  depends_on arch: :arm64 # For Swift 6.0
  depends_on :macos

  def install
    cd "libs/lume" do
      system "swift", "build", "--disable-sandbox", "-c", "release", "--product", "lume"
      system "/usr/bin/codesign", "-f", "-s", "-",
             "--entitlement", "resources/lume.entitlements",
             ".build/release/lume"
      bin.install ".build/release/lume"
    end
  end

  test do
    # Test ipsw command
    assert_match "Found latest IPSW URL", shell_output("#{bin}/lume ipsw")

    # Test management HTTP server
    # Serves 404 Not found if no machines created
    port = free_port
    fork { exec bin/"lume", "serve", "--port", port.to_s }
    sleep 5
    assert_match %r{^HTTP/\d(.\d)? (200|404)}, shell_output("curl -si localhost:#{port}/lume").lines.first
  end
end
