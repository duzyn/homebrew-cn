class Sqlpage < Formula
  desc "Web application framework, for creation of websites with simple database queries"
  homepage "https://sql.ophir.dev/"
  url "https://ghproxy.com/https://github.com/lovasoa/SQLpage/archive/refs/tags/v0.9.1.tar.gz"
  sha256 "9df8901b07dc0ce9346545dbb2f9823d3f33bd43443a7197238a76829015c479"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "99c5a2d322589759836c19fe89f0c7eda4bf35c2bb1f645a53ac1e288f535ebe"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9f7f0b18d2b6d66524a455953a1b75f82624f249bf72763a6776ea325369e960"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9705932d4a4afe4ea301b8bc73571da9e2dc6ef799ac5c2945752073d73f5e34"
    sha256 cellar: :any_skip_relocation, ventura:        "c7ddec6fdacb7ff1893730962265fe5c49874eb7a3c8ccbe91871baa27a0c8fd"
    sha256 cellar: :any_skip_relocation, monterey:       "70b7d3728da9ef520b24e01907c2511adb3f32cce665191dfbe06adee2728327"
    sha256 cellar: :any_skip_relocation, big_sur:        "cd9a102ff1da5848e56b8f7af75d3813d6fd5f560903b90467e8fc6085ba8632"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8e53cfc278831ff81cb27b4da7979ac48b628d75a53d09d5e5263c43f102ea5c"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    port = free_port
    pid = fork do
      ENV["PORT"] = port.to_s
      exec "sqlpage"
    end
    sleep(2)
    assert_match "It works", shell_output("curl -s http://localhost:#{port}")
    Process.kill(9, pid)
  end
end
