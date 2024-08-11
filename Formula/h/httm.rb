class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFS/btrfs"
  homepage "https://github.com/kimono-koans/httm"
  url "https://mirror.ghproxy.com/https://github.com/kimono-koans/httm/archive/refs/tags/0.41.1.tar.gz"
  sha256 "6b02ce49980636b067364717c51d5113153a4d40a02d6d8af1b5c7126ca02bc8"
  license "MPL-2.0"
  head "https://github.com/kimono-koans/httm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3c992a0cc73809d91f6e96970da9067e023c40a45e9900509908f20cab43e25d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e6e3d5b037977caba123bcf3e3afa8c779f928cb76482bf77b994deb71c347c6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ee7edaa95c9ce00f7a12204f1fe168da074cfc824942fda7a8e58b567c0306ad"
    sha256 cellar: :any_skip_relocation, sonoma:         "9555d247c643b047259df3096db1271dded09e31e9cee98c3cc4881dc90a6f82"
    sha256 cellar: :any_skip_relocation, ventura:        "399d3316bb0ca55bfad751fb9f1485ed683442e568664361c5359bcfc3acac67"
    sha256 cellar: :any_skip_relocation, monterey:       "5ea3c3903b836ce579f3aaba7f576e0d4c42cad4058fb08015d7dc1722279b58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d442767ab520940ea62bcccecd7f344ac34678b4fd84ee3642c27d58b9a6f3c4"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "acl"
  end

  conflicts_with "nicotine-plus", because: "both install `nicotine` binaries"

  def install
    system "cargo", "install", "--features", "xattrs,acls", *std_cargo_args
    man1.install "httm.1"

    bin.install "scripts/ounce.bash" => "ounce"
    bin.install "scripts/bowie.bash" => "bowie"
    bin.install "scripts/nicotine.bash" => "nicotine"
    bin.install "scripts/equine.bash" => "equine"
  end

  test do
    touch testpath/"foo"
    assert_equal "Error: httm could not find any valid datasets on the system.",
      shell_output("#{bin}/httm #{testpath}/foo 2>&1", 1).strip
    assert_equal "httm #{version}", shell_output("#{bin}/httm --version").strip
  end
end
