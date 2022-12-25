class CargoEdit < Formula
  desc "Utility for managing cargo dependencies from the command-line"
  homepage "https://killercup.github.io/cargo-edit/"
  url "https://github.com/killercup/cargo-edit/archive/v0.11.7.tar.gz"
  sha256 "73b3300afda280685be2a2391d5238aea341c2e15ac95ab288fa0f5ad38137fb"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "57b5b6273b132b7eb822e17a09f89b6605bbeede8d141858c4dbdd9dcf5dc306"
    sha256 cellar: :any,                 arm64_monterey: "7d5e6d0ed054eab45fd1facc2eda64d947de710ce674e94deee9fe66c322fbb2"
    sha256 cellar: :any,                 arm64_big_sur:  "34086245329042029a43c94d8cb9a18ef25c3a2262a32113b8c39ddf7f6d5ef8"
    sha256 cellar: :any,                 ventura:        "94deecc24a053295c766200d09e738f92a7fd65648752b59b4da9699d7cb38fb"
    sha256 cellar: :any,                 monterey:       "aab9d60e9316bb6f66c12589fb9e8575e17f475fec266828042b392d620dba5b"
    sha256 cellar: :any,                 big_sur:        "364a86ad39aad7335ef5df7ca695c30718e2545b3600e1180fa7c97293a4367d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9c8fa02debe0c1da2d0376a57407a6050cd1aecb1933f9efb6bd796850d45eee"
  end

  depends_on "libgit2"
  depends_on "openssl@1.1"
  depends_on "rust" # uses `cargo` at runtime

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    crate = testpath/"demo-crate"
    mkdir crate do
      (crate/"src/main.rs").write "// Dummy file"
      (crate/"Cargo.toml").write <<~EOS
        [package]
        name = "demo-crate"
        version = "0.1.0"

        [dependencies]
        clap = "2"
      EOS

      system bin/"cargo-set-version", "set-version", "0.2.0"
      assert_match 'version = "0.2.0"', (crate/"Cargo.toml").read

      system bin/"cargo-rm", "rm", "clap"
      refute_match(/clap/, (crate/"Cargo.toml").read)
    end
  end
end
