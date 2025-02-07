class Aptos < Formula
  desc "Layer 1 blockchain built to support fair access to decentralized assets for all"
  homepage "https://aptosfoundation.org/"
  url "https://mirror.ghproxy.com/https://github.com/aptos-labs/aptos-core/archive/refs/tags/aptos-cli-v6.1.0.tar.gz"
  sha256 "5aa8d51ca0c5f275e84e72de1cdab00769e4ef3189c191e048383273285b5784"
  license "Apache-2.0"
  head "https://github.com/aptos-labs/aptos-core.git", branch: "main"

  livecheck do
    url :stable
    regex(/^aptos-cli[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "761d884464a8fd6c4888d9692d63cad48b6960913ca247e01cafb7d0c82f6b55"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4037f5cedf027974586f45f8095ac96fae70e88c8e73e045c68f9345a1843ef5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b2d05d76ff941e90e4a8f4d7481ba04d9aad2ca960410ed347fb502c562c8b25"
    sha256 cellar: :any_skip_relocation, sonoma:        "e18cbfd87ba3351ef5f2f1817b325b3c72fad236624e629bbe8e7e52cec28a8c"
    sha256 cellar: :any_skip_relocation, ventura:       "2bd2d2349a2c01c43659995b3df82360fc490f84be5b5951301f2e6ccfd1b333"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3f4195a8a7ca978353af14146129f3885dbc84d4bb55414a25847ecdc7438645"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  uses_from_macos "llvm" => :build

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "zip" => :build
    depends_on "elfutils"
    depends_on "openssl@3"
    depends_on "systemd"
  end

  # rust 1.80.0 build patch, upstream pr ref, https://github.com/aptos-labs/aptos-core/pull/14272
  patch do
    url "https://github.com/aptos-labs/aptos-core/commit/72b9657316c699cfbef75216f578a0bd99e0be46.patch?full_index=1"
    sha256 "f93b4f8b0a61d245e13d6776834cec9ecdd3b0103d53b43dcc79cda3e3f787ed"
  end

  def install
    # FIXME: Look into a different way to specify extra RUSTFLAGS in superenv as they override .cargo/config.toml
    # Ref: https://github.com/Homebrew/brew/blob/master/Library/Homebrew/extend/ENV/super.rb#L65
    ENV.append "RUSTFLAGS", "--cfg tokio_unstable -C force-frame-pointers=yes -C force-unwind-tables=yes"
    system "cargo", "install", *std_cargo_args(path: "crates/aptos"), "--profile=cli"
  end

  test do
    assert_match(/output.pub/i, shell_output("#{bin}/aptos key generate --output-file output"))
  end
end
