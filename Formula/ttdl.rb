class Ttdl < Formula
  desc "Terminal Todo List Manager"
  homepage "https://github.com/VladimirMarkelov/ttdl"
  url "https://github.com/VladimirMarkelov/ttdl/archive/refs/tags/v3.5.0.tar.gz"
  sha256 "1329aef2127fe0bb1d90333946894cb1cb5a8fcd9ab90a8afbd4a0dadb303eab"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0286143bedf96c23a4e3be3d4a561dc23a6caa93c2113a12eb3bd7e43f28a613"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "90febc54771a2186c97cdd4d4dd3d3d94e6d469fc6d6726953791e1ed7e251e4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "209a00610379362f2d5b41682fbea871610c73274d60bb9c2648557ff2da41e6"
    sha256 cellar: :any_skip_relocation, ventura:        "4286391834a880b3406bcf708702e1b41de4c45be4f538975b650cc3713ed375"
    sha256 cellar: :any_skip_relocation, monterey:       "933edf3b7a52cb1679ff48a7e6df8f0d1a20dd075a8f74bac03a901401584790"
    sha256 cellar: :any_skip_relocation, big_sur:        "ec6a106a6b44af106692a9d7a2d851bbd801bd94b4105ac876a7443498735f51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "54816bdea7072cb98cb83ba36b79545e7b1bb12391dd56e2872e05adf2b4fcb8"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Added todo", shell_output("#{bin}/ttdl 'add readme due:tomorrow'")
    assert_predicate testpath/"todo.txt", :exist?
    assert_match "add readme", shell_output("#{bin}/ttdl list")
  end
end
