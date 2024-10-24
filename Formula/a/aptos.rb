class Aptos < Formula
  desc "Layer 1 blockchain built to support fair access to decentralized assets for all"
  homepage "https://aptosfoundation.org/"
  url "https://mirror.ghproxy.com/https://github.com/aptos-labs/aptos-core/archive/refs/tags/aptos-cli-v4.2.5.tar.gz"
  sha256 "98faa1d46fc8c8b136710c0abc53cb99e157c57e3c6fed20822407f3aeacad90"
  license "Apache-2.0"
  head "https://github.com/aptos-labs/aptos-core.git", branch: "main"

  livecheck do
    url :stable
    regex(/^aptos-cli[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b29b28ff1ba304255ed6d9fbabe9013324423d0214ca745ea09fde8ed743bcb6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "16f40fb63b2f8bb5d66409ca41f199ddd5901bd2ca41b7deb8e39d7381b557ef"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "935fb5cd9669431a5113b923dad9f8f5d8ba4383985bb6228bc68abf16ece2da"
    sha256 cellar: :any_skip_relocation, sonoma:        "c70d0effb30fa9e254d15aa60ca89b1b663136f687754d3cc5ac2318c03554dc"
    sha256 cellar: :any_skip_relocation, ventura:       "6a260e59ba53a75cc9b691c685e0c875bb145cb78cae88611a066108c8d25451"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5a39e179494cd656e2babba01d6f43c7fee9db85e226698aeb1aa22f5fc7fe7e"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  uses_from_macos "llvm" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "zip" => :build
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
