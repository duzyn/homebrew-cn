class Mago < Formula
  desc "Toolchain for PHP to help developers write better code"
  homepage "https://github.com/carthage-software/mago"
  # github tarball has issue, https://github.com/carthage-software/mago/issues/794
  url "https://static.crates.io/crates/mago/mago-1.4.0.crate"
  sha256 "094d59db1b23084656b4e1f478447fbdcb662ea1b7d665e2c9e75e0ff9cebcf6"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fc637c0e9809db1760cffca877b89eb3ecbc9753211733a846c3d21841a6f1d9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "81edb1b99ca6ffad96a0bf9d52069b3ed86438a0dfb7bc6ace56d368d93be7bc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3fa16bb3eafef1fd7bc025ad2c3f0ee75b788780f1ef9d8a9ca95cc3f5ac7437"
    sha256 cellar: :any_skip_relocation, sonoma:        "2bf805a0a90eb79c7019a594e32cca66d1439d0a4d38f791223bc0b0a561696e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bdda76ee09e475a43756c428dee6dfb161f2b08c0db0ea24a73853184bf12092"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "502c7c4c0f64955efc55ee82db4e4ea0ed78264a9e45d866eba57f980094982f"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mago --version")

    (testpath/"example.php").write("<?php echo 'Hello, Mago!';")
    output = shell_output("#{bin}/mago lint . 2>&1")
    assert_match " Missing `declare(strict_types=1);` statement at the beginning of the file", output

    (testpath/"unformatted.php").write("<?php echo 'Unformatted';?>")
    system bin/"mago", "fmt"
    assert_match "<?php echo 'Unformatted';?>", (testpath/"unformatted.php").read
  end
end
