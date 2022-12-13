class Ghorg < Formula
  desc "Quickly clone an entire org's or user's repositories into one directory"
  homepage "https://github.com/gabrie30/ghorg"
  url "https://github.com/gabrie30/ghorg/archive/refs/tags/v1.9.1.tar.gz"
  sha256 "82917744b06204ee721e865737a06f067e631b62ba78a19e5ba8b5c38afba896"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "04bb099974001fb8e548a97fd8a693f58f75c003a651a2676e011a37b90a25c2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "198afc4cfe23759a9e9625fe1452f353c9cbb19eef714995e68aec4e2091e86d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0cab8d16351e1b8f6dcc5e71acce0b8f9bb5aba050ef3c557758c1419c9e65da"
    sha256 cellar: :any_skip_relocation, ventura:        "59667469a63e7c1d327344bebbb0d93de1b674a99f3ff18f9fcb6a58a64ccdbf"
    sha256 cellar: :any_skip_relocation, monterey:       "b5917687534a68c7fc3a30d0f342c23edacf64a84fe49b7980f1ceea95de0dd3"
    sha256 cellar: :any_skip_relocation, big_sur:        "fbc46cb1cab56c9a2a71cebf2c3f0fc98003f0d4905c5b03240b9f1af29cbec4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7fa892c42ae42190a40bd20c6c89f8382b176a2228a3cc4e995b3a63f2991dc5"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"ghorg", "completion")
  end

  test do
    assert_match "No clones found", shell_output("#{bin}/ghorg ls")
  end
end
