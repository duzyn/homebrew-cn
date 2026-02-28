class BlockGooseCli < Formula
  desc "Open source, extensible AI agent that goes beyond code suggestions"
  homepage "https://block.github.io/goose/"
  url "https://mirror.ghproxy.com/https://github.com/block/goose/archive/refs/tags/v1.26.0.tar.gz"
  sha256 "81dd37bd1567f90b59a43ec16e2a13c759107c89b7da7c4dc3dd33e4f9f4a64b"
  license "Apache-2.0"
  head "https://github.com/block/goose.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8959d662d428686e63c04c38882c4d9319c1f98255db82c1049a9a3b17e49393"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7e26e0d45fe2a484bd9bc63805d81343869bc51e23aa4bdafd0a2fce4bf17152"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "314d4c9990cfcfc9f63f35a238a8a1b3c54587947c66b5bb16625d94fe8c4846"
    sha256 cellar: :any_skip_relocation, sonoma:        "981a69e7733f4a1f1e593f0bcf967da05d2e0ddbc83bbd61a63954da9a7873bb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e7b511e21518402fabe4e04c3bfd69b7dda28b65c6b24c4fc4f697077f0a91da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a4c721b4e35c83e97ae11b7587b944d886320297ebc3f995acb6fc3ca9d2ac76"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "protobuf" => :build # for lance-encoding
  depends_on "rust" => :build

  uses_from_macos "llvm" => :build # for libclang

  on_linux do
    depends_on "dbus"
    depends_on "libxcb"
    depends_on "zlib-ng-compat"
  end

  conflicts_with "goose", because: "both install `goose` binaries"

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/goose-cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goose --version")
    output = shell_output("#{bin}/goose info")
    assert_match "Paths:", output
    assert_match "Config dir:", output
    assert_match "Sessions DB (sqlite):", output
  end
end
