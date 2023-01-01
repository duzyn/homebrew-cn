class Geph4 < Formula
  desc "Modular Internet censorship circumvention system to deal with national filtering"
  homepage "https://geph.io/"
  url "https://github.com/geph-official/geph4-client/archive/refs/tags/v4.7.0.tar.gz"
  sha256 "cf2a61bfaf892e66a4b91cfe117295b3f28db765f80f3aef8be8178229becae0"
  license "GPL-3.0-only"
  head "https://github.com/geph-official/geph4-client.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1c8afa923ba90ea9ab61e97140f3dd44be9810577d5bcaf96fc4eca590817be0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8b3f01d45424a9049c7d08490c66390845774e7059b2a73fade880e1829c36d3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "42a4774b75e297dbb60abe63cfcce889eb5c1211cd1b6e6aa5ccb158f3f3a03a"
    sha256 cellar: :any_skip_relocation, ventura:        "4ec757e59f17b0e86e26f93e0996482e7669750b1c9941353da594c056427436"
    sha256 cellar: :any_skip_relocation, monterey:       "4a170d9b8139b90dd5b7661be08ff0053fea7ad458b136e026a5cbfa853d5d44"
    sha256 cellar: :any_skip_relocation, big_sur:        "91e385f02682e899bfb54f8ddf4169a409c340078daef160f758de0d8e8d6aa1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ee743ee32ff4728b0fc8f0c3d95bd8f0ae74327fac2a904142c93c37984aa4e0"
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
