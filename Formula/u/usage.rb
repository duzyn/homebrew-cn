class Usage < Formula
  desc "Tool for working with usage-spec CLIs"
  homepage "https://usage.jdx.dev/"
  url "https://mirror.ghproxy.com/https://github.com/jdx/usage/archive/refs/tags/v0.8.1.tar.gz"
  sha256 "0d80734b4b6952e2b79bc09b3f63a58781443fa824b389d16d87251662d79c6e"
  license "MIT"
  head "https://github.com/jdx/usage.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bf3ec0d72b07989829579f73de932b2f0eec63fdfcd628ed9c0fb698944b25a3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3e064aef83925a11e35ddab217c8b7fe4be5ad422a84aa8ea415c73aaf97c63f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "53ee4fdb68586dd3879598c08424f9ab0e976c7d14aff9b9b712c82f7a1a55e0"
    sha256 cellar: :any_skip_relocation, sonoma:        "1d77b2eeba71d2c3c8d31ca6f6a7b57a7e272bf475c2376491a441596cef23e9"
    sha256 cellar: :any_skip_relocation, ventura:       "01d6026ce853ef4f728041d66ea99dbb8e1accdbd0bce32c66651ecb7aafbbac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9fa4a30b151fc72365d3d2b2adae363e740cdbdefee88d63d56cfdf1a8fe7eed"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
  end

  test do
    assert_match "usage-cli", shell_output(bin/"usage --version").chomp
    assert_equal "--foo", shell_output(bin/"usage complete-word --spec 'flag \"--foo\"' -").chomp
  end
end
