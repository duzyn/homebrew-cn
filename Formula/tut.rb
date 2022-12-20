class Tut < Formula
  desc "TUI for Mastodon with vim inspired keys"
  homepage "https://tut.anv.nu"
  url "https://github.com/RasmusLindroth/tut/archive/refs/tags/1.0.28.tar.gz"
  sha256 "6dbc41e0615e1e2a2e1d56ecf2a3a9f555bb39ab16fabc8f4a0cdc35735188bf"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9301299267ad5f2c4b1a5fbd7a1045f437b906e536993f212cd56b658ed5009d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "36e431183b548bc81cbd26c1388cb4f637f8107647f42bc5ed3d065bd9cb6cb8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bd87af613abfb9d9a50749bb4fff379bc3668e7469f97b306c7c2aa159386906"
    sha256 cellar: :any_skip_relocation, ventura:        "409d49cac69943814056e2d8e2f0a4602c485215da006ee2895b335c46550778"
    sha256 cellar: :any_skip_relocation, monterey:       "84cd9780ff9e119a55ce0da32432301794c901313122dd043d9a8cda910e7506"
    sha256 cellar: :any_skip_relocation, big_sur:        "bc3e64e51e466ec34ac86e8a1995452c50974bc624e36c7bee3d38178bde2a29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8b57307a8f945e83c85713a994900391b157a65fe283d92f270601bd40dca2c0"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tut --version")
    assert_match "Instance:", pipe_output("#{bin}/tut --new-user 2> /dev/null")
  end
end
