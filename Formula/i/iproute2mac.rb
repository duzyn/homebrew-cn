class Iproute2mac < Formula
  include Language::Python::Shebang

  desc "CLI wrapper for basic network utilities on macOS - ip command"
  homepage "https://github.com/brona/iproute2mac"
  url "https://mirror.ghproxy.com/https://github.com/brona/iproute2mac/releases/download/v1.5.0/iproute2mac-1.5.0.tar.gz"
  sha256 "c0999a7c06a2dbc781a89935c55be0c09f51569c1cdc0809ad8010cdb751e029"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1b55d4a07c67d7315c47c6f009653d85bc98843f672a3162f09f9434098ff26b"
  end

  depends_on :macos
  depends_on "python@3.12"

  def install
    libexec.install "src/iproute2mac.py"
    libexec.install "src/ip.py" => "ip"
    libexec.install "src/bridge.py" => "bridge"
    rewrite_shebang detected_python_shebang, libexec/"ip", libexec/"bridge", libexec/"iproute2mac.py"
    bin.write_exec_script (libexec/"ip"), (libexec/"bridge")
  end

  test do
    system "/sbin/ifconfig -v -a 2>/dev/null"
    system bin/"ip", "route"
    system bin/"ip", "address"
    system bin/"ip", "neigh"
    system bin/"bridge", "link"
  end
end
