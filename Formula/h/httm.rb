class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFS/btrfs"
  homepage "https://github.com/kimono-koans/httm"
  url "https://mirror.ghproxy.com/https://github.com/kimono-koans/httm/archive/refs/tags/0.31.3.tar.gz"
  sha256 "01a137411fd6331b2e39cd764139b3ea0997851079cf973fe9faab8bedca6597"
  license "MPL-2.0"
  head "https://github.com/kimono-koans/httm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "83ff7b1ec7c76ea56b3bb86a9dce4f062fa553fd83bb13e673ff17878984d698"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "80cda2fb51b12a87e86826e4f5f6a5a6239e67c1a42c0e3c2ec99a227dbe140b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b85e2328521dd973479bc605fe119908bb402da183db001b4f582cf3bf0e66a2"
    sha256 cellar: :any_skip_relocation, sonoma:         "7fd2c1988006ac0b40f8825341307d2669bbffe7f4372bc1356c1f4e5416bfe8"
    sha256 cellar: :any_skip_relocation, ventura:        "5a18eb83f943aa22cdf034f6cb8d6c012da65b11278180980fd3a6f3be4e2c27"
    sha256 cellar: :any_skip_relocation, monterey:       "9088e2d9082d7df1069c43bc110767d95860675e804e744c960fb7bf35d34d0d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "37f75f44d9d9e74fb817b38be4cc6b0ed83ce093f79be8633cdd2c1c479913b0"
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
