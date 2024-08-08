class Iproute2mac < Formula
  include Language::Python::Shebang

  desc "CLI wrapper for basic network utilities on macOS - ip command"
  homepage "https://github.com/brona/iproute2mac"
  url "https://mirror.ghproxy.com/https://github.com/brona/iproute2mac/releases/download/v1.5.2/iproute2mac-1.5.2.tar.gz"
  sha256 "1e9874b0cb3a18c98dc80f234322f5924e361d80bfd4b6581fca7f9874bcad4f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "61aa3fa174d8fe048d9f39e6d162063bd43ab3d258b05126599fc1cebb55a6fc"
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
