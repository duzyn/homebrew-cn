class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20221130.dbb2d2a.tar.gz"
  version "20221130"
  sha256 "e824c50e8c699aea356372c250366322849bbaf8fefcedc94b48d6c0134d1ec7"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3211927583654f1da7051ff07e7f9460b340c30399f223adfbb51514997a9a67"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "76504dba8cb938b97e8c086e8a2e8e9cee6fb89e7bacfeef8df24674bcc2f5ab"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f125d4c4a70bb26c7aabea68ea5b383630c9a376cd92e69ebdc06d73b5b4288c"
    sha256 cellar: :any_skip_relocation, ventura:        "56647fb65e088419441eaf1b24ed15a318d9eef74d28db1d4054ab7d75352214"
    sha256 cellar: :any_skip_relocation, monterey:       "843c466d29c20eff47cf5f715eb91aec88c4265bc49e0ff12b62ea2e45584e85"
    sha256 cellar: :any_skip_relocation, big_sur:        "d13b054e9ebe234beb832b9551a48725dce9fec7c97b1350d70f6a3c0864deb3"
    sha256                               x86_64_linux:   "397ff270855a18c159bee7ad2249bdbe256d8e194a9dfdb0f250054e2dd326a0"
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
