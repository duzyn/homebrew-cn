class Oxipng < Formula
  desc "Multithreaded PNG optimizer written in Rust"
  homepage "https://github.com/shssoichiro/oxipng"
  url "https://github.com/shssoichiro/oxipng/archive/v7.0.0.tar.gz"
  sha256 "2a669c9b966cb54f8247c0accc9d90502944359abdd4143d9162d64e0acbaf76"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "06ac808c6843ca65e8f9ab63db87b07ba878d2b149608c6c0d638d445e18c0b8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f993a504b828e26e8c400bbd5a62484767026834f09f31da7538e4acdbf36e1a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d0fbb4d7d35f806b07abe38e130ac96b717bbab3f510220a40e6087196820b7b"
    sha256 cellar: :any_skip_relocation, ventura:        "c107d783b4a267a710628183a111e85c47d3ae5eac3110507d5b4d14a37f0f2d"
    sha256 cellar: :any_skip_relocation, monterey:       "bac8611490422655bcc6ca459e5b6fdf115d7a926163df34fc5eaf1464d92ed5"
    sha256 cellar: :any_skip_relocation, big_sur:        "82212b7804b3e1cf5b6a4c403d50a4187b6d882f975aae913d749fe0771b92df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "693450abe6a5168b3b92fea51fe21e1e0f40d32367bad3440c15419326313fdd"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"oxipng", "--pretend", test_fixtures("test.png")
  end
end
