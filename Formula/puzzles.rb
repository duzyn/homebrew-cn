class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20221218.11c1447.tar.gz"
  version "20221218"
  sha256 "9e2e80141ac570e4b5cd3d23ab01e1878266ccee9489ca3fbaf05aa344fb6db5"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "178492a09df2ea49316b662cbb8ae4aae53022b5c76800fc0638e00a8ca9728d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f759121b0bf8d2a3360af38afaa8428778419aa2f7da5872a37cc84761594bce"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ff5f027b442f74eb5626c4d2403994cf25b7d70869395460eb723041221a5c8a"
    sha256 cellar: :any_skip_relocation, ventura:        "eb4d667c6461ab95f38c042a955d757c344898b9a50c107a47c6be6866fd642a"
    sha256 cellar: :any_skip_relocation, monterey:       "f0fa350764a47893b493a038e7e1ef34853eff50cce7d0ed1adfd1f33bcc4fc1"
    sha256 cellar: :any_skip_relocation, big_sur:        "cfba9b56b1ced80fb291941a4f660948183cd3567737520d55fb1a99f81e66f6"
    sha256                               x86_64_linux:   "d089068d6b9ef2752a5fa262eb03a334d86bc8fca84bd356d761916efeb0b574"
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
