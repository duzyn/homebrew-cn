class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://mirror.ghproxy.com/https://github.com/rvben/rumdl/archive/refs/tags/v0.1.17.tar.gz"
  sha256 "5f78772a3828651ae56285f9d93760de9010b0d0159b25b453c631c5d1d19c51"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5d1808a775b40da9f1f5758aacdb4d2310c22d995ed568729127c8e9adcca691"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4dae1d165aa6527d381daf9fc8a960906a5cbaf9ab62e93e738bb61c4300b9f9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ba1c8545f19aa3d88eeb708e304f5adaf2833c63f39638140da4d3fe83b626ab"
    sha256 cellar: :any_skip_relocation, sonoma:        "f2326fc7e15d0031eec0f34c15cccc439846832d9c215c5af1579ac487d0e74d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "422c105e1c2d4a98c1e61cb117fce5959da1bbaf061e0f9bd22e19bd8fa32d8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "69a79fb433988b3c76b73ac01cd0ccd42974c28d405cfc0f9e694ca4e4bf32a8"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rumdl version")

    (testpath/"test-bad.md").write <<~MARKDOWN
      # Header 1
      body
    MARKDOWN
    (testpath/"test-good.md").write <<~MARKDOWN
      # Header 1

      body
    MARKDOWN

    assert_match "Success", shell_output("#{bin}/rumdl check test-good.md")
    assert_match "MD022", shell_output("#{bin}/rumdl check test-bad.md 2>&1", 1)
    assert_match "Fixed", shell_output("#{bin}/rumdl fmt test-bad.md")
    assert_equal (testpath/"test-good.md").read, (testpath/"test-bad.md").read
  end
end
