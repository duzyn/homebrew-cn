class Geph4 < Formula
  desc "Modular Internet censorship circumvention system to deal with national filtering"
  homepage "https://geph.io/"
  url "https://github.com/geph-official/geph4-client/archive/refs/tags/v4.6.6.tar.gz"
  sha256 "a10582bdc20b72054877d65aa5a30d0702a63a6362f60edd4960c9be5dc3f7d3"
  license "GPL-3.0-only"
  head "https://github.com/geph-official/geph4-client.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6f850cf29e82fe7843f7961dbba7068cce7d353cc8ed464a98a0f79e773ef7d5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fa5aea8f46cbaefb7b21c1402c7b9bc4ab1fa971b4519877b177db5dbcaf8511"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a9f9164a2d6fcc0f9a5ecea293ff20330e0a592c5aa330b962886a49fdfa7b7e"
    sha256 cellar: :any_skip_relocation, ventura:        "cc3d92b9b9cb76727c6c5a4a59cf76a423892893bc6145a8196e96c5b86a1fff"
    sha256 cellar: :any_skip_relocation, monterey:       "3f114a24ca43d7a4d9bdb75b0fd66748f1f4ba8a71f22b266dbde7329a05f739"
    sha256 cellar: :any_skip_relocation, big_sur:        "41789253cb4b588b80b1a90371b70d3ee5456ab8a397c0f69798c6abc5be085d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fba7de32a3b2013ba70f5ff8e86177c4c6abf6cc8c2644f300b237745e25d313"
  end

  depends_on "rust" => :build

  def install
    (buildpath/".cargo").rmtree
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Error: invalid username or password",
     shell_output("#{bin}/geph4-client sync --credential-cache ~/test.db 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}/geph4-client --version")
  end
end
