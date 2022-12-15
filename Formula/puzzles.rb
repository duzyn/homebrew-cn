class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20221214.8acb84e.tar.gz"
  version "20221214"
  sha256 "f32e7cf339d6c05fada13ad10cf145058f428e1c50fcdb5b73c308cadc8668e5"
  license "MIT"
  head "https://git.tartarus.org/simon/puzzles.git", branch: "main"

  # There's no directory listing page and the homepage only lists an unversioned
  # tarball. The Git repository doesn't report any tags when we use that. The
  # version in the footer of the first-party documentation seems to be the only
  # available source that's up to date (as of writing).
  livecheck do
    url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/doc/"
    regex(/version v?(\d{6,8})(?:\.[a-z0-9]+)?/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "717b4856fdfa9c602b4a593a3d6ce993f0ba9d8e35f870ed397ff1364c7a9860"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6dfbb2b244141f18df951caf1cd5bde64ea81924a45b28a76dc9364581f67e64"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fc9d2b899627ecae45f2f5fa5a68f74cab92bc87ea40fa97cc779a60641575e7"
    sha256 cellar: :any_skip_relocation, ventura:        "db6e0be33dd330554d17fe9ce0e821197dd2bb1bb709b6cc3d418c127661337e"
    sha256 cellar: :any_skip_relocation, monterey:       "2e187db980c1915d7a505a038219d858630520cbe088eb34e9ef019a1f388c09"
    sha256 cellar: :any_skip_relocation, big_sur:        "b46d05a31484b3e94946d39dab4a3ccfe7a2bb88a7c02367cc39012a4c735172"
    sha256                               x86_64_linux:   "0bfcc5738c42aac3bc121b6f700a314f919ef8983d3a7bdaa8293f76694664e0"
  end

  depends_on "cmake" => :build
  depends_on "halibut" => :build

  on_linux do
    depends_on "imagemagick" => :build
    depends_on "pkg-config" => :build
    depends_on "cairo"
    depends_on "gdk-pixbuf"
    depends_on "glib"
    depends_on "gtk+3"
    depends_on "pango"
  end

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"

    bin.write_exec_script prefix/"Puzzles.app/Contents/MacOS/Puzzles" if OS.mac?
  end

  test do
    if OS.mac?
      assert_predicate prefix/"Puzzles.app/Contents/MacOS/Puzzles", :executable?
    else
      return if ENV["HOMEBREW_GITHUB_ACTIONS"]

      assert_match "Mines, from Simon Tatham's Portable Puzzle Collection", shell_output(bin/"mines")
    end
  end
end
