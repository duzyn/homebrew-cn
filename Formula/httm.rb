class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFS/btrfs"
  homepage "https://github.com/kimono-koans/httm"
  url "https://github.com/kimono-koans/httm/archive/refs/tags/0.19.0.tar.gz"
  sha256 "eabdf533280af248c5ded19f0b8224aad9682606faac6c85c0bd0a573e0736d0"
  license "MPL-2.0"
  head "https://github.com/kimono-koans/httm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0bce83245b36508249b947c5415e8ea8eeed8d2345964fbed036841b684bafe2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d9de6ec365c12e72bb8e8f0c2681ca2d8b0a2246ad585e59d878a8b021c8cea7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "371b2893f305685cdc63b25d82b4d228656cb0b3133032a39d6e778fb27e1a91"
    sha256 cellar: :any_skip_relocation, ventura:        "f6bcd264811e07c7b86a25c008b32a382fde8e9cff4fed6c89263e038de2905f"
    sha256 cellar: :any_skip_relocation, monterey:       "c56bf2adc18cf22f25664ffb8a3aaa77e977e97836cba52f0b3d49ea542d7027"
    sha256 cellar: :any_skip_relocation, big_sur:        "3ca96db4b81d49bfc47c1b2fedfc1f6321872a3b5d6641e71b0a6e2bd1eb52a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "77e0e388af3afcce2abb8ee470712683a72acab813edbedb5a98cc7a57b79c77"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "httm.1"
  end

  test do
    touch testpath/"foo"
    assert_equal "Error: httm could not find any valid datasets on the system.",
      shell_output("#{bin}/httm #{testpath}/foo 2>&1", 1).strip
    assert_equal "httm #{version}", shell_output("#{bin}/httm --version").strip
  end
end
