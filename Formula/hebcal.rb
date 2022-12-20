class Hebcal < Formula
  desc "Perpetual Jewish calendar for the command-line"
  homepage "https://github.com/hebcal/hebcal"
  url "https://github.com/hebcal/hebcal/archive/v5.7.0.tar.gz"
  sha256 "88a1f2492b4be94f2ad32d42441e996938f3c637c5e6e7e13120b01d8fa09db2"
  license "GPL-2.0-or-later"
  head "https://github.com/hebcal/hebcal.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0f1a2ae8cde8b4b4b88a135cb1e48e4134b66c6a8b2120ca44091d948a2cc0c6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0f1a2ae8cde8b4b4b88a135cb1e48e4134b66c6a8b2120ca44091d948a2cc0c6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0f1a2ae8cde8b4b4b88a135cb1e48e4134b66c6a8b2120ca44091d948a2cc0c6"
    sha256 cellar: :any_skip_relocation, ventura:        "bd9bbdbf589ddc86d9754f94262cc7c1b815abefe7431894bb0caa83be072ba2"
    sha256 cellar: :any_skip_relocation, monterey:       "bd9bbdbf589ddc86d9754f94262cc7c1b815abefe7431894bb0caa83be072ba2"
    sha256 cellar: :any_skip_relocation, big_sur:        "bd9bbdbf589ddc86d9754f94262cc7c1b815abefe7431894bb0caa83be072ba2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "905898e646904d4dd7065316c23cb6e65715280c0c8c81703db6b9e871eb292c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    output = shell_output("#{bin}/hebcal 01 01 2020").chomp
    assert_equal output, "1/1/2020 4th of Tevet, 5780"
  end
end
