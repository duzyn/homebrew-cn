class CargoDeny < Formula
  desc "Cargo plugin for linting your dependencies"
  homepage "https://github.com/EmbarkStudios/cargo-deny"
  url "https://github.com/EmbarkStudios/cargo-deny/archive/refs/tags/0.13.5.tar.gz"
  sha256 "aebfff46cf510fc9a85ce0059e88792c6467f44c17dd29badce50a13af47e4f7"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/EmbarkStudios/cargo-deny.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2a60f355a3fd9c26b718ab101f8254dd2833c225f04aaca5c834b4ceb03c8c33"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9377e21588e242c5a7df3535949b95cafedbec3cec8560b3638c843d3cd041c0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5f7acd050ff3531569a0eb933d92068106e78f2a94a794c5bd7d2adcab83733b"
    sha256 cellar: :any_skip_relocation, ventura:        "bb74b7cf66bf337220f0ae1aab51869ae40f55e64ae1cb7f4cbd92cf30edacc0"
    sha256 cellar: :any_skip_relocation, monterey:       "c0ccbb7929741d90d495f3422b4c647957f4dced7c2954156e0c428665a58d5b"
    sha256 cellar: :any_skip_relocation, big_sur:        "8d7aaa2a7409b67bfbc18e5173b45032823948ec87cddf27b8307b47db6edb2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b5b9e7fe103e52b1037b71a2cf70fcf998d99ae407189d2315421128fae1919b"
  end

  depends_on "rust" # uses `cargo` at runtime

  def install
    system "cargo", "install", *std_cargo_args
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

      output = shell_output("cargo deny check 2>&1", 1)
      assert_match "advisories ok, bans ok, licenses FAILED, sources ok", output
    end
  end
end
