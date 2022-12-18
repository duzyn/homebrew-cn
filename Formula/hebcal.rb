class Hebcal < Formula
  desc "Perpetual Jewish calendar for the command-line"
  homepage "https://github.com/hebcal/hebcal"
  url "https://github.com/hebcal/hebcal/archive/v5.6.0.tar.gz"
  sha256 "eb26d15a1ad186bde9ff1efebe8cd1238a2dd09a378a0d39989aed5057146347"
  license "GPL-2.0-or-later"
  head "https://github.com/hebcal/hebcal.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8048021c5a519bce4f412b747edae20cc5c716dd0de5eeb53c8ab75a5d4f72d9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8048021c5a519bce4f412b747edae20cc5c716dd0de5eeb53c8ab75a5d4f72d9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8048021c5a519bce4f412b747edae20cc5c716dd0de5eeb53c8ab75a5d4f72d9"
    sha256 cellar: :any_skip_relocation, ventura:        "04267fa869dfa251100d1db8e57d8afb14e152565a87db85d096e17641bf8c6f"
    sha256 cellar: :any_skip_relocation, monterey:       "04267fa869dfa251100d1db8e57d8afb14e152565a87db85d096e17641bf8c6f"
    sha256 cellar: :any_skip_relocation, big_sur:        "04267fa869dfa251100d1db8e57d8afb14e152565a87db85d096e17641bf8c6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "de588a074ccb392ae4428092a18b80eb35e7a0291fa799389b7ddf8da1467c0c"
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
