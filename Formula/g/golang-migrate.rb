class GolangMigrate < Formula
  desc "Database migrations CLI tool"
  homepage "https://github.com/golang-migrate/migrate"
  url "https://mirror.ghproxy.com/https://github.com/golang-migrate/migrate/archive/refs/tags/v4.18.0.tar.gz"
  sha256 "e277b8acfd2202288073ec59673801e7613575d2d59220c62fc3036feda78c7f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "278a67cd515a37ef573cedbe50fc9ac8e2d3cb560d399ab372475cac0fe31583"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6e3e7ca1e0e3e9ea5618bca7a9c0bc32eff5da406f3ea693b49869a6bdeced37"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "739a97abdc2f577423298961cfe49a67a18f77dc477a35d68f1d5ddcb1a99a94"
    sha256 cellar: :any_skip_relocation, sonoma:         "34a884fecf96b2f40858214554b3ca5a035b455ca26c2cb179cdb414ee5de540"
    sha256 cellar: :any_skip_relocation, ventura:        "bafe0660f7058aec2e6ff00311473cb03a8b6c850183254f0d9b45db782daf0f"
    sha256 cellar: :any_skip_relocation, monterey:       "a8278c0cfdbb9415d14f305c6390451b83e2a294dc72642261c1a45928b393f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "43820a4b0927c3c0584cbe5850e7acf996059c0e04a3c4e7cd2c7505c8f6b659"
  end

  depends_on "go" => :build

  def install
    system "make", "VERSION=v#{version}"
    bin.install "migrate"
  end

  test do
    touch "0001_migtest.up.sql"
    output = shell_output("#{bin}/migrate -database stub: -path . up 2>&1")
    assert_match "1/u migtest", output
  end
end
