class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://mirror.ghproxy.com/https://github.com/rvben/rumdl/archive/refs/tags/v0.1.31.tar.gz"
  sha256 "b4096dcdb825e69f92462671f9ef14eb25dd2d665a1ce52b2c6e0b31689499ed"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "20b0de35198a9f2b4784c5b47cf436c9396322441cfb80a2361bc4c85fe0091f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c88fe81ea493f145a974f8ce98a095d3a403e1f9870fa029751c89ee86fa645c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "20fff995a24f2efcfe7b573bcda94edd9d24252637d6b9a460a922318a2c6128"
    sha256 cellar: :any_skip_relocation, sonoma:        "c0c9b2c07e27911629f85fdc18bddbb2e0c360cdc6b2579a0749477cdb678d2c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7f72a9adbb71fcc4e252905bda37f7237080c1c51c04feb4a17427843b58a40e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f9e98f11cf0ffa25666c2f57e436a431adf0656ef4edc7dfd12a192933efdb8e"
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
