class Difftastic < Formula
  desc "Diff that understands syntax"
  homepage "https://github.com/Wilfred/difftastic"
  url "https://github.com/Wilfred/difftastic/archive/refs/tags/0.39.0.tar.gz"
  sha256 "ba05464d8a5c77374cb9a07d901eda56c67f4d558def515454bc4b7431c8ca38"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9a94c891161a70d6571f609c45280b8339fff7c4b587e1de926408cd684174b9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ceb0e283c08bed9e02f83532a37f1a5995b9c3cf69b8b8d91635a45fdc776768"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "095a930e877399228f4bdd2590a95bcfe190532432019fd23241cdcf10f7a7cb"
    sha256 cellar: :any_skip_relocation, ventura:        "95ec6afb5d8c1944c3f936227ff097bfa07c7858e68497e155d474df71d18816"
    sha256 cellar: :any_skip_relocation, monterey:       "6220aca7f7ab65cbdab7b57f5f5c7bcbe5e8621e67a5f818d8ca7b35fb3a4dff"
    sha256 cellar: :any_skip_relocation, big_sur:        "c34ab15664e7147fb25974530cc1bc9fd6017661c4e401254866816c325eb407"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "972c5217fc2cf17346911b86ef225abf7ef4f67867e21d6280f75df3e2e85d25"
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
