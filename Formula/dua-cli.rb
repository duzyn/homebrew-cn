class DuaCli < Formula
  desc "View disk space usage and delete unwanted data, fast"
  homepage "https://lib.rs/crates/dua-cli"
  url "https://github.com/Byron/dua-cli/archive/refs/tags/v2.18.2.tar.gz"
  sha256 "2c247fcfccc2f4bceb7746e038ea897d2f2e60190bead380b0dcb7a1e2d15b90"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "da1a06e3d5636fad29f1d9b059323e1ad0fe7a0eea2ac10c11ca3b66f2c65b3f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1da848be66ab7070dca45df873b26e7501284a5bdaeb4c155f82eb9f95a0b2ab"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b0de1d6f4d4a108eca3005536e817cd8663f05d7fa31ee311da0b04d68d49749"
    sha256 cellar: :any_skip_relocation, ventura:        "07138bb7ba1aa8235500825cbd49638678f021bea09607cd609b612897e650d5"
    sha256 cellar: :any_skip_relocation, monterey:       "160212b71876a440dc1459964edd54bfc8c0bdfdd4cf94bf53e8a004a503c3b1"
    sha256 cellar: :any_skip_relocation, big_sur:        "886ba2a986b74afed76447f20b04ff306b41f8d6bc4b128aed0f2778e59fc466"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0890923bf4bdbb5cbc50878514052a6e3b618403dea04b136ce1350b25b76731"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Test that usage is correct for these 2 files.
    (testpath/"empty.txt").write("")
    (testpath/"file.txt").write("01")

    expected = <<~EOS
      \e[32m      0  B\e[39m #{testpath}/empty.txt
      \e[32m      2  B\e[39m #{testpath}/file.txt
      \e[32m      2  B\e[39m total
    EOS

    assert_equal expected, shell_output("#{bin}/dua -A #{testpath}/*.txt")
  end
end
