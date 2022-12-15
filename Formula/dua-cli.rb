class DuaCli < Formula
  desc "View disk space usage and delete unwanted data, fast"
  homepage "https://lib.rs/crates/dua-cli"
  url "https://github.com/Byron/dua-cli/archive/refs/tags/v2.19.0.tar.gz"
  sha256 "fcbf2d9dbcdad2db17d2a3b690fb05d69ad3953237f2971d546d341339bf6271"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c656dd5db50f4b6c0b3929ee26c20509c3049b736bfb56156b79902d8e83f030"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7c418798198a941200bafbff149718fd68fbeb562a42b1e5bd2c1ef8f9580b31"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ad934dc90d4244f8ada781c1578f97d7906d9eab85ca492c0306bd5129b77cba"
    sha256 cellar: :any_skip_relocation, ventura:        "39a94f06ad1d1a11523019d2fe716fceeb2209c96e391c885809969dd864b0dd"
    sha256 cellar: :any_skip_relocation, monterey:       "34e4ea8105dda9757a032a0edf46eba61e37c7aef54b222f365338c93e8e55c2"
    sha256 cellar: :any_skip_relocation, big_sur:        "13c953dab15d9b77c39b803872c1186e3dac6181d7c68645a5addaa31609c80c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "761e419fe2244d40cd7495cef6a5e375e7e7237bf8334f5b62fcb655d4cc398f"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Test that usage is correct for these 2 files.
    (testpath/"empty.txt").write("")
    (testpath/"file.txt").write("01")

    expected = <<~EOS
      \e[32m      0  B\e[39m #{testpath}/empty.txt
      \e[32m      2  B\e[39m #{testpath}/file.txt
      \e[32m      2  B\e[39m total
    EOS

    assert_equal expected, shell_output("#{bin}/dua -A #{testpath}/*.txt")
  end
end
