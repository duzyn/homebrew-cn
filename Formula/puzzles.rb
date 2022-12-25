class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20221224.d332973.tar.gz"
  version "20221224"
  sha256 "69310c500711724bac81e7e6a280e1dcfcd864d666b7bb44cbf242f2f54005bc"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "519eb69919905d7c5984890fafb7d161670efb02063ea3cb9c2f8b38ba38dec6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dc010cf9e016f797fad2da826435a2871711c7ded0706041d3c0a3253607d1ce"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "66a4f6f657abeb599c70246ffd56557abfb914b8d04453684201d762fdd3b881"
    sha256 cellar: :any_skip_relocation, ventura:        "3b50963325f1e4adc74e2221b89f74ce815ed4f44823b41be6b9bc564cb4d40f"
    sha256 cellar: :any_skip_relocation, monterey:       "0043189c239a859a2f2d46895c79d760244ca18decc6e9e752f35f43f9cce1c0"
    sha256 cellar: :any_skip_relocation, big_sur:        "e517c0b15ab948aa68cb631fa0fd8df0c9351eb26aab8b2b7b0806ff624e672b"
    sha256                               x86_64_linux:   "cb218275394c457b956f7d039bd64d06c7aee4a4e604860729123b8c74b15202"
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
