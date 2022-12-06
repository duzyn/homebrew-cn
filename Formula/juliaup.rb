class Juliaup < Formula
  desc "Julia installer and version multiplexer"
  homepage "https://github.com/JuliaLang/juliaup"
  url "https://github.com/JuliaLang/juliaup/archive/v1.8.12.tar.gz"
  sha256 "30356cad26ed13c484520a9f76a5426e959a5209054589168394a4cab7bb853f"
  license "MIT"
  head "https://github.com/JuliaLang/juliaup.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8ca0106f3ee61a7812de603531696e85c6bab01d3c54bc1464fe7fb1646ccc9a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b965d8af679ec8e4a257dee894660bab328fb7ff880f8ca481c72caa77727c69"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8586320e34b73e136ecfedd18a7949066816a91cba64f6dd0b145960c0e61933"
    sha256 cellar: :any_skip_relocation, ventura:        "1a2093103b532921231c83ba19c7a4d696a14a3e0dc9d810cb5953d69d9a65c3"
    sha256 cellar: :any_skip_relocation, monterey:       "d2853f56850086b4e76fe25c13b9cc9bb722f47c637009f6f3b08f2cbd114b07"
    sha256 cellar: :any_skip_relocation, big_sur:        "edeae353be84996fda83e5153d321860335c5830c764c1e1401488aaa7e3ebd4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9720db2bd44ef586314d156db8ef3f46e53d36e0647dfe571ceea9546138efac"
  end

  depends_on "rust" => :build

  conflicts_with "julia", because: "both install `julia` binaries"

  def install
    system "cargo", "install", "--bin", "juliaup", *std_cargo_args
    system "cargo", "install", "--bin", "julialauncher", *std_cargo_args

    bin.install_symlink "julialauncher" => "julia"
  end

  test do
    expected = "Default  Channel  Version  Update"
    assert_equal expected, shell_output("#{bin}/juliaup status").lines.first.strip
  end
end
