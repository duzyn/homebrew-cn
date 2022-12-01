class Macpine < Formula
  desc "Lightweight Linux VMs on MacOS"
  homepage "https://beringresearch.github.io/macpine/"
  url "https://github.com/beringresearch/macpine/archive/refs/tags/v0.7.tar.gz"
  sha256 "47777dee26c6c9c0d0683e9e6b0d8dd85b20c1336cbeffaa9f1be0b6fcedf8d7"
  license "Apache-2.0"
  head "https://github.com/beringresearch/macpine.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "17724ae6ba9ff82b9d55cb7d51f0fa5641fa568569c27350083c6d88dbe2dcd8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "be6eacbba1713dd2a5014bce46eb72ad3303272fd285b44bdafd3d1b892ba094"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4a57f7dce7aa83d375d014b5a9c8cccfeb09cd3078d70feffccee520ddc1af78"
    sha256 cellar: :any_skip_relocation, ventura:        "427c9caab46cd89a59ba627271cbc6d7611c8e3e75669ffa84606a7968f0610b"
    sha256 cellar: :any_skip_relocation, monterey:       "83acd669c461cf5b20cd4585c3b40d257b746c2f387e523c65c89a829b4ee566"
    sha256 cellar: :any_skip_relocation, big_sur:        "edb32132706f0919e66cd22df2bbe95d16564abe0cdf7e5d22e89960e21da34d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e5bb38a7419f1314f36fe04c8f7aa94870e2bf12499ec08dba72ff24d1619b07"
  end

  depends_on "go" => :build
  depends_on "qemu"

  conflicts_with "alpine", because: "both install `alpine` binaries"

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_match "NAME OS STATUS SSH PORTS ARCH PID", shell_output("#{bin}/alpine list")
  end
end
