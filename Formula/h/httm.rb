class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFS/btrfs"
  homepage "https://github.com/kimono-koans/httm"
  url "https://mirror.ghproxy.com/https://github.com/kimono-koans/httm/archive/refs/tags/0.35.0.tar.gz"
  sha256 "36820a490bdea90f22d17eb6bd2712bfe6dacba939ec078be1ca418f1d0f6530"
  license "MPL-2.0"
  head "https://github.com/kimono-koans/httm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3c889c79ed2ccefe1669da1ed94000fd4af52945db83519f71218848f5167266"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "366dd1466a3b0ef6f4cb771c486e1c5695751af5b830ce84e77513f1bd9e7a61"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8b81bbf74094b854fc26882d7acedfc97227c0d2920a8d893372d1c834651d1b"
    sha256 cellar: :any_skip_relocation, sonoma:         "62a172e4b68ad9a49a9abcea527da5fd3e6f63d2cc9c881324c499a72bb651fd"
    sha256 cellar: :any_skip_relocation, ventura:        "9583265aff8c9da5a86c633ec6b765f4d28b4e12bf2ef8d5dd875df6bbf714b6"
    sha256 cellar: :any_skip_relocation, monterey:       "8f51478f579d5ed60b4f966890be63711c9217f9d5fd66d750172a5d2d705cf9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3702662496efdcfcd177222e0551850a247673ed486389d677fb7fe30ff461d3"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "acl"
  end

  def install
    system "cargo", "install", "--features", "xattrs,acls", *std_cargo_args
    man1.install "httm.1"

    bin.install "scripts/ounce.bash" => "ounce"
    bin.install "scripts/bowie.bash" => "bowie"
    bin.install "scripts/nicotine.bash" => "nicotine"
    bin.install "scripts/equine.bash" => "equine"
  end

  test do
    touch testpath/"foo"
    assert_equal "Error: httm could not find any valid datasets on the system.",
      shell_output("#{bin}/httm #{testpath}/foo 2>&1", 1).strip
    assert_equal "httm #{version}", shell_output("#{bin}/httm --version").strip
  end
end
