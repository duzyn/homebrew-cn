class Bvm < Formula
  desc "Version manager for all binaries"
  homepage "https://github.com/bvm/bvm"
  url "https://mirror.ghproxy.com/https://github.com/bvm/bvm/archive/refs/tags/0.4.2.tar.gz"
  sha256 "d60c2e49bdac1facd9c17e21e3dac52767ead2fd50b1a94f484fb6d180b0acbd"
  license "MIT"
  head "https://github.com/bvm/bvm.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "77c86700c2ad4220696d4af07c442fe92b53cea5e984e8f636f885de525e84dc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "693a77a710934aefc58c70c85b463347e029e23cac7e497bbd4710d56331421f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "35791169d51be8b50901c4380b330595af3c4ff02495c90a412dbdffc9ed0785"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7618a44251a99f34f374c7e2007d189d277b83a215fb076b8c2cef8acf2d08c1"
    sha256 cellar: :any_skip_relocation, sonoma:         "6e366569dbb656130ff6e439ca2bf7c0a4977a80b232879bfd89eaf2a619252e"
    sha256 cellar: :any_skip_relocation, ventura:        "110898dd99e162b59e0065c5ba6bcd0890c9dad376ce12e0657ebbcc6366b4bc"
    sha256 cellar: :any_skip_relocation, monterey:       "2c52d9ee186a37ed791283aa03ce80f9346d26ab4fca7ede7d9c29137a739d9f"
    sha256 cellar: :any_skip_relocation, big_sur:        "d21190edd6a8ff77a8ae0174b016a16952d25e20f78910ae0c54d156067c1155"
    sha256 cellar: :any_skip_relocation, catalina:       "3c3ee94eebad836efb69ffadd95785c5991602451c08ab9cf396a44c9536bf21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a19b280d30c8ab515c180d095a592d0a4ddcee2a69737d439bb67320a002c10f"
  end

  # See: https://github.com/bvm/bvm/commit/44419a291f56aa483ea83d710a440e85dfeae91c
  disable! date: "2024-02-01", because: :repo_archived

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
    bin.install_symlink "bvm-bin" => "bvm"
  end

  test do
    system bin/"bvm", "init"
    assert_predicate testpath/"bvm.json", :exist?

    assert_match version.to_s, shell_output("#{bin}/bvm --version")
  end
end
