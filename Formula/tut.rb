class Tut < Formula
  desc "TUI for Mastodon with vim inspired keys"
  homepage "https://tut.anv.nu"
  url "https://github.com/RasmusLindroth/tut/archive/refs/tags/1.0.33.tar.gz"
  sha256 "975efa73d985d59b6f8ae1322ab3da3555f6004eff5f0b9303413fc20850c02a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fc383254b174de306679225ed3d2287d591c10ed31a508123bf1b462c8d01a91"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0b58eea8a0e4f3be88e22c913f7dae013e8f671e4cc4bef1ffb4c836a91ed085"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a56ea5f39fdddcbfacac968bcbf0fa09383d0c1bdb344e9d81eef1ca69635b45"
    sha256 cellar: :any_skip_relocation, ventura:        "a2f45fd45b3b6118d57e78b9b98cc2a7efae68e823abe21c44c99bb201243cbd"
    sha256 cellar: :any_skip_relocation, monterey:       "ed8bc901b2791847aa8642882071472aa8d9021175c3e6bbd1205c30374ab501"
    sha256 cellar: :any_skip_relocation, big_sur:        "3c9b3fa1f6a4e5d1677c5f0de004325502511a2cbe0edbd825251a04cabcbf2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c5f95c3155f57caf239485b7ae5070886f92b6bc4066d522e0f16855ba4266dc"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tut --version")
    assert_match "Instance:", pipe_output("#{bin}/tut --new-user 2> /dev/null")
  end
end
