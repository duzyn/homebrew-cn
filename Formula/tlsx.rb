class Tlsx < Formula
  desc "Fast and configurable TLS grabber focused on TLS based data collection"
  homepage "https://github.com/projectdiscovery/tlsx"
  url "https://github.com/projectdiscovery/tlsx/archive/v1.0.2.tar.gz"
  sha256 "133c4c66ac39d7347cfacaeb19c2bc0ba7be8a0c83cba6621cbd079050cf5ed4"
  license "MIT"
  head "https://github.com/projectdiscovery/tlsx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6d1c762f8861e70a8a16900d8d2436b604b18f53af4620832a82c3997c068696"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1b500ee343dc1d9eae7c3cc643995d59c71335ca1bff7e848b89a101d66bb075"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e06d07ea4a58ac02b0c06791cb095c77ab014c3e7676d34b3b39768c0d083590"
    sha256 cellar: :any_skip_relocation, ventura:        "b630a8c77d2bf99adbdec269f77b0a0c77f4b16916be07e98562a524f6d105c5"
    sha256 cellar: :any_skip_relocation, monterey:       "d764e7ca71c879ff9111e86f5c96181acf17753858e575f5239493b1cb9589db"
    sha256 cellar: :any_skip_relocation, big_sur:        "4489ce0c3bf0c045c254d23d971b0a80884fe8a7531b9ccaa388ba7ea09e505b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a9798b47701fd9af9d0e159ab66dbff5e71efc2fd389d5f930d18397035007da"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/tlsx/main.go"
  end

  test do
    system "tlsx", "-u", "expired.badssl.com:443", "-expired"
  end
end
