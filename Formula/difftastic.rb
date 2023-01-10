class Difftastic < Formula
  desc "Diff that understands syntax"
  homepage "https://github.com/Wilfred/difftastic"
  url "https://github.com/Wilfred/difftastic/archive/refs/tags/0.41.0.tar.gz"
  sha256 "2dfb85b86fbde11976c83ff057610bd9fc2ebe3b8dc99d1ecaff28231e13cf45"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fbceb11d47218ac283eb4995b2f02870bebc4516bc78339da6fb54d6a6341e9b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2416f4bb0c83d6f47c2ea748509252612bf0cb1f5497b3b6b89dc9e93cd555b3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2df7a4ee78aab769cf868d252f588d376e638355c2db1cb3c058fa52f052d992"
    sha256 cellar: :any_skip_relocation, ventura:        "912d7e47f078819f26d4781e712ea74abbfe51dfccb22aacc2e322ca28a02de0"
    sha256 cellar: :any_skip_relocation, monterey:       "a3b84253bc15a318226ddc39434af37fc40927cb6935aa8d068ce8d2d1bc65ed"
    sha256 cellar: :any_skip_relocation, big_sur:        "3e520b82cf7c61360d53faa1119d6bfe9ed5b31d919516c7bc1e25094414f9b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f8954478c8e041286e6d87438aab7eaaba030db98897b95ad461594ddc61a9c4"
  end

  depends_on "rust" => :build

  fails_with gcc: "5"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"a.py").write("print(42)\n")
    (testpath/"b.py").write("print(43)\n")
    expected = <<~EOS
      b.py --- Python
      1 print(42)                             1 print(43)\n
    EOS
    assert_equal expected, shell_output("#{bin}/difft --color never --width 80 a.py b.py")
  end
end
