class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFS/btrfs"
  homepage "https://github.com/kimono-koans/httm"
  url "https://github.com/kimono-koans/httm/archive/refs/tags/0.19.1.tar.gz"
  sha256 "f6386fe30218dd0611c21c0f6a79bcfcd0a61a3c8527ae89bc03614dc5fb99a3"
  license "MPL-2.0"
  head "https://github.com/kimono-koans/httm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8a672d13cafb34355c8bf9bd92cf7250959dbc1c2bb3ec9aa86a3f08e19bbe31"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2f895caf349bc89352dcf71b1abb9fe3b287acd02c0397ddc04e38437c64222d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3920bcea7f509edd3fd1b4b4058fefee820b736f1940d0ea0504e1f056fdf5ce"
    sha256 cellar: :any_skip_relocation, ventura:        "c00a56d849a92873cfe575e3dc7708030df26a1f1cb5979abefe63110fa8c009"
    sha256 cellar: :any_skip_relocation, monterey:       "766e14c27a52a3970a5faca381422cf84e9c6d789c8310f89caa8eb224b70bd4"
    sha256 cellar: :any_skip_relocation, big_sur:        "160eccb24e89d7842a9f02c919c06b8b8cfa80ef1c99d1be667ad35c1555eb56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "79941030aaafd5b5a101aed2eddf83e9612429286cb333219a549bc0fea62750"
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
