class Sniffnet < Formula
  desc "Cross-platform application to monitor your network traffic"
  homepage "https://github.com/GyulyVGC/sniffnet"
  url "https://github.com/GyulyVGC/sniffnet/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "c957a372b324aa8349820458202d291f64831b90aeae5b73d822e74e7739876d"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/GyulyVGC/sniffnet.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6207bddc411420dc8a3f616960b21e2635c98184451baa8684b4d97b8e314ce1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d9c2438a7a496eacff0f57960701066da0b838b1451345d354734679c37535db"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "51f25c2304b66ffaadb7bd823dec59800bacfb311d3d0ac2fe75ab4475230510"
    sha256 cellar: :any_skip_relocation, ventura:        "a3022a44ffeb505a713c6c68c26dfa7941443f864dbfe12733bf1b17eae1fce8"
    sha256 cellar: :any_skip_relocation, monterey:       "18525e3ab8a68b6a9ad0b607eda361ca51a2ae957b414aa985ccf22563d31186"
    sha256 cellar: :any_skip_relocation, big_sur:        "1d6e0766d38235e9708bf3deae1a8d41144c49324e6953a719678dc49e6c38a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "afb8aa75c4417b6882dc94a4e1fc036a36c5d32cc91729ecc8e059ff2e601052"
  end

  depends_on "rust" => :build

  uses_from_macos "libpcap"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "fontconfig"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    pid = fork do
      # sniffet is a GUI application
      exec bin/"sniffnet"
    end
    sleep 1
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
