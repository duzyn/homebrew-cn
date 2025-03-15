class Mago < Formula
  desc "Toolchain for PHP to help developers write better code"
  homepage "https://github.com/carthage-software/mago"
  url "https://mirror.ghproxy.com/https://github.com/carthage-software/mago/archive/refs/tags/0.20.1.tar.gz"
  sha256 "eee38f8dda323131b1fbb99c450592cd9676be258f753ced2c4bdba85489c2ab"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e5c369d86b351baad1a509e2ed63c49bfce604e41462fbe0b6b11b392b965237"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d8a1da104500892e1d05f25b67556254aaa965e73f722bccffa002f59e41a17e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "147de4b2fb0c7d070acd82ecc23ba1d186499ccba2be94bf513970a9cd9e874a"
    sha256 cellar: :any_skip_relocation, sonoma:        "a0d8f4c0cd4ea30cc0b41b10bca9d10653b9efea6ef47e8f1b9f6e97deb3afec"
    sha256 cellar: :any_skip_relocation, ventura:       "c3585a20790bcca94f936993b383ebd911994a0a105bb4ccea8475d3a3434dca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "022e7f26035d407671806744e798dfd7ffe5f59ff66b664fee63e6041d2cd874"
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
    output = shell_output("#{bin}/mago lint 2>&1")
    assert_match " Missing `declare(strict_types=1);` statement at the beginning of the file", output

    (testpath/"unformatted.php").write("<?php echo 'Unformatted';?>")
    system bin/"mago", "fmt"
    assert_match "<?php echo 'Unformatted';\n", (testpath/"unformatted.php").read
  end
end
