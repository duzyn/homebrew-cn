class CargoNextest < Formula
  desc "Next-generation test runner for Rust"
  homepage "https://nexte.st"
  url "https://github.com/nextest-rs/nextest/archive/refs/tags/cargo-nextest-0.9.47.tar.gz"
  sha256 "dbd685b0ef4e4e632ed0ee7136526a0daa1e73b11df5fd9b04a06ccd83557a1c"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^cargo-nextest[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "de5a9933399a34b98c79f9f9740ef70e3e0684b59a303cd4265b088c0393b76e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1eaee54c60767c353209acb634efae6e17edaf9361fc71d8f63c6ea5f4189917"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "78af54c5bf7edbd5dc3ebd0f441c0ef01892a95280973a66bdfc74ba0153815d"
    sha256 cellar: :any_skip_relocation, ventura:        "0d197e6c8d49abd9005efe1d4b470ed88fe07e5ddf6db4977ff9b60313aaabd1"
    sha256 cellar: :any_skip_relocation, monterey:       "229c206e2037a631883a97d209da531b7abb3f397a01754514923db91fa9b869"
    sha256 cellar: :any_skip_relocation, big_sur:        "e4a2ff63dc81559621039278ba7a3005ef6c4d6e0d59eed7d80a48d7c65a39c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b63e3903ab575ab1093faf1a1a938b656b06c565e4cc27785a0ca625e75a9177"
  end

  depends_on "rust" # uses `cargo` at runtime

  def install
    # Fix a performance regression. This can be removed once Rust 1.64 is stable.
    # See https://github.com/nextest-rs/nextest/releases/tag/cargo-nextest-0.9.30
    ENV["RUSTC_BOOTSTRAP"] = "1"
    ENV["RUSTFLAGS"] = "--cfg process_group --cfg process_group_bootstrap_hack"
    system "cargo", "install", "--no-default-features", "--features", "default-no-update",
                    *std_cargo_args(path: "cargo-nextest")
  end

  test do
    crate = testpath/"demo-crate"
    mkdir crate do
      (crate/"src/main.rs").write <<~EOS
        #[cfg(test)]
        mod tests {
          #[test]
          fn test_it() {
            assert_eq!(1 + 1, 2);
          }
        }
      EOS
      (crate/"Cargo.toml").write <<~EOS
        [package]
        name = "demo-crate"
        version = "0.1.0"
      EOS

      output = shell_output("cargo nextest run 2>&1")
      assert_match "Starting 1 tests across 1 binaries", output
    end
  end
end
