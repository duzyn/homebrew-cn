class Mdfried < Formula
  desc "Terminal markdown viewer"
  homepage "https://github.com/benjajaja/mdfried"
  url "https://mirror.ghproxy.com/https://github.com/benjajaja/mdfried/archive/refs/tags/v0.17.2.tar.gz"
  sha256 "35c0b44a07b8277a581e4b357e11c1fa5b2144612c822bfa6258427bfd7b4edf"
  license "GPL-3.0-or-later"
  head "https://github.com/benjajaja/mdfried.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c43eaf0fbb2377d772e086fd6e3ad48ca00ff3d96b53ac36496137a1796224f1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e7e2add9ad480cc2493fc083f83b6fa49a9ce3bd0f793a4994a1abad18135b33"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6d4084b54d907a185ee76c743b6db5e61a207fae9dc37db71293a66f8b2bdcec"
    sha256 cellar: :any_skip_relocation, sonoma:        "3440172079b14936fcd292ff08a500b7f8554dc1b261f1628d305262df09b846"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "317fe4341b41263fe80b0346f77c7cb83935740e4929b615a20b39705f616124"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "615715ac216d9e709cf7204bfd669bcc24566f98a56e3b505e3896e80309cfc1"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mdfried --version")

    # IO error: `No such device or address (os error 6)`
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    (testpath/"test.md").write <<~MARKDOWN
      # Hello World
    MARKDOWN

    output = shell_output("#{bin}/mdfried #{testpath}/test.md 2>&1")
    assert_match "cursor position could not be read", output
  end
end
