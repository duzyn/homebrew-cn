class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20221217.f967bfa.tar.gz"
  version "20221217"
  sha256 "c885b2a43a705c2c12721cee415c2e327a2cc9ec24717fcafd9980dcc82140ac"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c9f28692e58a99b7e1ffce32096ad28d72def37e1a1a25af5ec3be9526798fdf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0d6d4c873413141cca32affceb2fef3d922fdecb0596796a97dd10fb45383186"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e02796198ce2736f1f8606dfdd53598635f7021205a3e1342097fb9be3079af6"
    sha256 cellar: :any_skip_relocation, ventura:        "6992fd9da9ba7dd0109222e85bfce455d142a16392b35f295d77f1bdfc172e6b"
    sha256 cellar: :any_skip_relocation, monterey:       "83c6696be07e9a83a90ca471adacf054568a04264187bc5d6564029fa52f5f97"
    sha256 cellar: :any_skip_relocation, big_sur:        "bfde5510c42d03204d76cd1bcdcdf111b2175fb6d0c362f712dcd578a7562a1e"
    sha256                               x86_64_linux:   "bd1566e43f652f374e336d060390ffc3b9badbca88cafdd01c624908ae7d3e9e"
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
