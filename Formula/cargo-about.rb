class CargoAbout < Formula
  desc "Cargo plugin to generate list of all licenses for a crate"
  homepage "https://github.com/EmbarkStudios/cargo-about"
  url "https://github.com/EmbarkStudios/cargo-about/archive/refs/tags/0.5.2.tar.gz"
  sha256 "7e37c2d47273dfedbace33d34f768690a9a5ef7e04a347dd1a3f5b0a979ee50a"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/EmbarkStudios/cargo-about.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "16a070bc96dee9e68662e51eaa30930b376696ebccaf772a63b904b74767ea91"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e66b8c934ba62c681da3e9306786216ee2f99e5b82ef94d84be3a3fdc03587c1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8cbc35efac28eed7ab75ad652855b29d0b685a06cc1c4337254959727636b863"
    sha256 cellar: :any_skip_relocation, ventura:        "b5ffc939efa22d6d1d48fd700ef46192b10770fcc1d582deabc025394f11354e"
    sha256 cellar: :any_skip_relocation, monterey:       "5c4c876a38d66c15d00fffdbd26edb9d8385dd1fd6a6c8f6c651b5f198354a64"
    sha256 cellar: :any_skip_relocation, big_sur:        "3033a58b98b55299efcd96f414b88a4f25505f680ed44197f4bf75d3c7d9300b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a05c60a220c6ef2d0e55ec425996952acb46fd7d92e102638acfa1f36a06ec6a"
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
        license = "MIT"
      EOS

      system bin/"cargo-about", "init"
      assert_predicate crate/"about.hbs", :exist?

      expected = <<~EOS
        accepted = [
            "Apache-2.0",
            "MIT",
        ]
      EOS
      assert_equal expected, (crate/"about.toml").read

      output = shell_output("cargo about generate about.hbs")
      assert_match "The above copyright notice and this permission notice", output
    end
  end
end
